import requests
import wolframalpha

app_id = "ETUYXG-KTKHVQ24U8"
inp = "y%3Dx%2B1"

# r = requests.get("http://api.wolframalpha.com/v2/query?appid=" + app_id + "&input=" + inp)
# print(r.status_code)
# print(r.content)

client = wolframalpha.Client(app_id)
res = client.query("y = x + 1")
for pod in res.pods:
	if pod.title == 'Plot':
		# print(pod)
		for sub in pod.subpods:
			print(sub['img']['@src'])