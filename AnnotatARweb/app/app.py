import os
from flask import Flask, redirect, url_for, render_template, request, send_from_directory
from werkzeug.utils import secure_filename
import wolframalpha


UPLOAD_FOLDER = 'uploads/'
ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/')
def hello_world():
	userquery = request.args.get("userquery")
	if userquery is not None:
		if '/' in userquery:
			return 'No plots found'
		return redirect(url_for("get_plot", userquery=userquery))
	return render_template('index.html')

@app.route('/query/<string:userquery>')
def get_plot(userquery):
	app_id = 'ETUYXG-KTKHVQ24U8'
	client = wolframalpha.Client(app_id)
	reformatted = userquery.replace("#", "/")
	reformatted = reformatted.replace("_", "/")
	print(reformatted)
	try:
		res = client.query(reformatted)
		for pod in res.pods:
			print(pod)
			if 'Plot' in pod.title or 'plot' in pod.title:
				for sub in pod.subpods:
					if '@src' in sub['img']:
						return sub['img']['@src']
	except:
		return 'No plots found'
	return 'No plots found'

@app.route('/upload')
def upload():
	return render_template('upload.html')

@app.route('/uploader', methods=['GET', 'POST'])
def upload_file():
	if request.method == 'POST':
		f = request.files['file']
		f.save('./uploads' + f.filename)
		print(f)
		return 'file uploaded successfully'

@app.route('/file/<string:filename>')
def display_file(filename):
	# return send_from_directory(app.config['UPLOAD_FOLDER'], filename)
	url = '/uploads/' + filename
	print(os.listdir('./uploads'))
	print(url)
	with open(url, 'r') as f:
		content = f.read()
	return 'hello'
	# return render_template('displayfile.html', content=content)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

if __name__ == '__main__':
    app.run()

