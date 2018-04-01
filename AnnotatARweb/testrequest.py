import requests

r = requests.get("https://annotatear.herokuapp.com/query/y%3D2x%5E2%2B5x%2B1")

print(r.text)