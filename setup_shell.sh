#!/bin/bash

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

sudo cp ~/go/bin/subfinder /usr/local/bin/

go install -v github.com/tomnomnom/anew@latest

sudo cp ~/go/bin/anew /usr/local/bin/

sudo apt install assetfinder

go install -v github.com/PentestPad/subzy@latest

sudo cp ~/go/bin/subzy /usr/local/bin/

go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

sudo cp ~/go/bin/httpx /usr/local/bin/

sudo apt install dirsearch

CGO_ENABLED=1 go install github.com/projectdiscovery/katana/cmd/katana@latest

sudo cp ~/go/bin/katana /usr/local/bin/

go install github.com/tomnomnom/waybackurls@latest

sudo cp ~/go/bin/waybackurls /usr/local/bin/

GO111MODULE=on go install github.com/jaeles-project/gospider@latest

sudo cp ~/go/bin/gospider /usr/local/bin/

sudo apt install arjun

sudo apt install nuclei

sudo apt install amass

git clone https://github.com/defparam/smuggler.git

go install github.com/Brosck/mantra@latest

sudo cp ~/gopath/bin/mantra /usr/local/bin/

git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git

go install github.com/BishopFox/jsluice/cmd/jsluice@latest

sudo cp ~/go/bin/jsluice /usr/local/bin/