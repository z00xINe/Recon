import requests
import urllib.parse
import sys

def print_separator():
    print("\n" + "=" * 59)
    print("=" * 59 + "\n")

def main(api_key):
    endpoints = [
        {
            "description": "Static Map",
            "url": f"https://maps.googleapis.com/maps/api/staticmap?center=45%2C10&zoom=7&size=400x400&key={api_key}"
        },
        {
            "description": "Street View",
            "url": f"https://maps.googleapis.com/maps/api/streetview?size=400x400&location=40.720032,-73.988354&fov=90&heading=235&pitch=10&key={api_key}"
        },
        {
            "description": "Embed Place",
            "url": f"https://www.google.com/maps/embed/v1/place?q=place_id:ChIJyX7muQw8tokR2Vf5WBBk1iQ&key={api_key}"
        },
        {
            "description": "Directions",
            "url": f"https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood4&key={api_key}"
        },
        {
            "description": "Geocode",
            "url": f"https://maps.googleapis.com/maps/api/geocode/json?latlng=40,30&key={api_key}"
        },
        {
            "description": "Distance Matrix",
            "url": f"https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615,-73.9976592|40.6905615,-73.9976592|40.6905615,-73.9976592|40.6905615,-73.9976592|40.6905615,-73.9976592|40.6905615,-73.9976592|40.659569,-73.933783|40.729029,-73.851524|40.6860072,-73.6334271|40.598566,-73.7527626|40.659569,-73.933783|40.729029,-73.851524|40.6860072,-73.6334271|40.598566,-73.7527626&key={api_key}"
        },
        {
            "description": "Find Place From Text",
            "url": f"https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum%20of%20Contemporary%20Art%20Australia&inputtype=textquery&fields=photos,formatted_address,name,rating,opening_hours,geometry&key={api_key}"
        },
        {
            "description": "Place Autocomplete",
            "url": f"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=Bingh&types=(cities)&key={api_key}"
        },
        {
            "description": "Elevation",
            "url": f"https://maps.googleapis.com/maps/api/elevation/json?locations=39.7391536,-104.9847034&key={api_key}"
        },
        {
            "description": "Timezone",
            "url": f"https://maps.googleapis.com/maps/api/timezone/json?location=39.6034810,-119.6822510&timestamp=1331161200&key={api_key}"
        },
        {
            "description": "Nearest Roads",
            "url": f"https://roads.googleapis.com/v1/nearestRoads?points=60.170880,24.942795|60.170879,24.942796|60.170877,24.942796&key={api_key}"
        },
        {
            "description": "Geolocation",
            "url": f"https://www.googleapis.com/geolocation/v1/geolocate?key={api_key}"
        }
    ]

    for endpoint in endpoints:
        print(endpoint["url"])
        try:
            response = requests.get(endpoint["url"])
            print(response.text)
        except Exception as e:
            print(f"Error fetching data from {endpoint['description']}: {e}")
        print_separator()

if __name__ == "__main__":
    x = input("Enter your Google Maps API key: ")
    main(x)
