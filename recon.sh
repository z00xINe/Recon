#!/bin/bash

subfinder -up

katana -up

nuclei -up

httpx -up

cd ~/bug_bounty

mkdir $1

cd ~/bug_bounty/$1

for domain in "$@"; do

	echo ""
	echo "==========================================================="
	echo "==========================================================="
	echo "[+] Downloading domain list from ShrewdEye"
	echo "==========================================================="
	echo "==========================================================="
	echo ""

	wget "https://shrewdeye.app/domains/"$domain".txt"
	cat $domain.txt | anew >> urls.txt
	rm $domain.txt

	echo ""
	echo "==========================================================="
	echo "==========================================================="
	echo "[+] Gathering subdomains with subfinder..."
	echo "==========================================================="
	echo "==========================================================="
	echo ""

	subfinder -d $domain -all --recursive >> subfinder.txt
	cat subfinder.txt | anew >> urls.txt
	rm subfinder.txt

	echo ""
	echo "==========================================================="
	echo "==========================================================="
	echo "[+] Gathering subdomains with assetfinder..."
	echo "==========================================================="
	echo "==========================================================="
	echo ""

	echo $domain | assetfinder --subs-only >> assetfinder.txt
	cat assetfinder.txt | anew >> urls.txt
	rm assetfinder.txt

done

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Checking for vulnerable subdomains with subzy..."
echo "==========================================================="
echo "==========================================================="
echo ""

subzy run --targets urls.txt --hide_fails --vuln --concurrency 1000

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Running nuclei against the subdomains..."
echo "==========================================================="
echo "==========================================================="
echo ""

nuclei -l urls.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] See the working sites by httpx..."
echo "==========================================================="
echo "==========================================================="
echo ""

cat urls.txt | httpx -o httpx.txt
cat httpx.txt | httpx -mc 200 -o httpx200.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Scan for the existence of the /.git directory on target domains"
echo "==========================================================="
echo "==========================================================="
echo ""

httpx -path /.git -sc --silent

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Check if the Git config file is accessible (can reveal sensitive repo info)"
echo "==========================================================="
echo "==========================================================="
echo ""

httpx -path /.git/config -sc --silent

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Check if the Git HEAD log is accessible (can expose commit history or sensitive data)"
echo "==========================================================="
echo "==========================================================="
echo ""

httpx -path /.git/logs/HEAD -sc --silent

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Fuzz for a time-based SQL injection vulnerability using a forged X-Forwarded-For header"
echo "[+] If the response time is greater than 13s, it's a possible blind SQLi"
echo "==========================================================="
echo "==========================================================="
echo ""

cat urls.txt | httpx -silent -H "X-Forwarded-For: 'XOR(if(now()=sysdate(),sleep(13),0))OR" -rt -timeout 20 -mrt '>13'

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Check for exposed phpinfo.php pages on a list of urlss and grep for the signature 'phpinfo()'"
echo "==========================================================="
echo "==========================================================="
echo ""

httpx -l urls.txt --status-code --title -path /phpinfo.php | grep 'phpinfo()'

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Gathering URLs by Katana..."
echo "==========================================================="
echo "==========================================================="
echo ""

katana -list httpx.txt -o katana.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Gathering URLs by WayBackURLs..."
echo "==========================================================="
echo "==========================================================="
echo ""

cat httpx.txt | waybackurls >> wayback.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Gathering URLs by GoSpider..."
echo "==========================================================="
echo "==========================================================="
echo ""

gospider -S httpx.txt | sed -n 's/.*\(https:\/\/[^ ]*\)]*.*/\1/p' >> gospider.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Collect all outputs in one file 'urls.txt'..."
echo "==========================================================="
echo "==========================================================="
echo ""

cat katana.txt wayback.txt gospider.txt | anew >> urls.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Grep js files..."
echo "==========================================================="
echo "==========================================================="
echo ""

cat urls.txt | grep -E "\.js" >> js.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Grep php files..."
echo "==========================================================="
echo "==========================================================="
echo ""

cat urls.txt | grep -E "\.php$" >> php.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Analysis php..."
echo "==========================================================="
echo "==========================================================="
echo ""

arjun -i php.txt | tee -a parameters.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Analysis js by mantra..."
echo "==========================================================="
echo "==========================================================="
echo ""

cat js.txt | mantra | tee -a mantra.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Analysis js by jsluice..."
echo "==========================================================="
echo "==========================================================="
echo ""

mkdir jsluice

cd jsluice/

for i in `cat ../js.txt`; do wget $i; done

for i in `ls .`; do jsluice secrets $i; done

for i in `ls .`; do jsluice urls $i; done

cd ..

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Running nuclei for js analysis..."
echo "==========================================================="
echo "==========================================================="
echo ""

nuclei -l js.txt -t ~/nuclei-templates/http/exposures/ -o nucleijs.txt

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Fuzzing by dirsearch..."
echo "==========================================================="
echo "==========================================================="
echo ""

dirsearch --full-url -l $(pwd)/httpx.txt -i 200 -e conf,config,bak,backup,swp,old,db,sql,asp,aspx,aspx~,asp~,py,py~,rb,rb~,php,php~,bak,bkp,cache,cgi,conf,csv,html,inc,jar,js,json,jsp,jsp~,lock,log,rar,old,sql,sql.gz,http://sql.zip,sql.tar.gz,sql~,swp,swp~,tar,tar.bz2,tar.gz,txt,wadl,zip,.log,.xml,.js.,.json

echo ""
echo "==========================================================="
echo "==========================================================="
echo "[+] Use smuggler to check request smuggling vulnerablitiy"
echo "==========================================================="
echo "==========================================================="
echo ""

cat httpx.txt | smuggler | tee -a smuggler.txt