from flask import Flask, redirect, url_for
from flask import render_template
from flask import request
import wolframalpha

app = Flask(__name__)

@app.route('/')
def hello_world():
	userquery = request.args.get("userquery")
	if userquery is not None:
		return redirect(url_for("get_plot", userquery=userquery))
	return render_template('index.html')

@app.route('/about')
def about():
    return 'The about page'

@app.route('/query/<string:userquery>')
def get_plot(userquery):
	app_id = 'ETUYXG-KTKHVQ24U8'
	client = wolframalpha.Client(app_id)
	res = client.query(userquery)
	for pod in res.pods:
		if 'Plot' in pod.title or 'Plots' in pod.title:
			for sub in pod.subpods:
				if '@src' in sub['img']:
					return sub['img']['@src']
	return 'No plots found'

if __name__ == '__main__':
    app.run()

