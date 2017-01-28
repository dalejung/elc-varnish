from flask import Flask
import datetime
app = Flask(__name__)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def hello_world(path):
    return path + ' :: ' + str(datetime.datetime.now())

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
