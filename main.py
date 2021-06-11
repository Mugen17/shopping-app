from flask import Flask, render_template, session
from model import *
from extensions import db
from routes import *
from settings import *
from utils import *
from passlib.hash import sha256_crypt
import base64
from os import listdir
from werkzeug import datastructures
import json

# Customizing jinja options for sake of preference
class CustomFlask(Flask):
	jinja_options = Flask.jinja_options.copy()
	jinja_options.update(dict(
		variable_start_string='%%',
		variable_end_string='%%',
	))


app = CustomFlask(__name__)
# Adding all blueprints
app.register_blueprint(userRoutes, url_prefix="/user")
app.register_blueprint(cartRoutes, url_prefix="/cart")
app.register_blueprint(itemRoutes, url_prefix="/item")
app.register_blueprint(orderRoutes, url_prefix="/order")
app.secret_key = SECRET_KEY

# Connecting to database
app.config['SQLALCHEMY_DATABASE_URI'] = SQL_CONNECTION
db.init_app(app)

try:
	with app.app_context():
		# Creating tables if none exist
		if(len(db.engine.table_names())==0):
			db.create_all()
			db.session.commit()
			logging.info(CREATING_TABLES_SUCCESS)
	logging.info(TABLES_EXIST)
except Exception as e:
	logging.error(str(e))

# Function to create an admin user
def createAdmin():
	try:
		with app.app_context():
			# Setting token as admin and isAdmin flag to true
			createUserUtil("admin","admin","admin","admin",True)
		logging.info(ADMIN_CREATED)
	except Exception as e:
		logging.error(str(e))

# Functions to create initial 10 items
def addItems():
	# Reading from json seed file
	path = './static/items.json'
	with open(path,"rb") as f:
		data = json.load(f)
		items = data['items']
		for item in items:
			name = item['name']
			description = item['description']
			price = item['price']
			imgPath = item['path']
			# Getting image from path extracted from seed file
			with open(imgPath,"rb") as imgFile:
				image = datastructures.FileStorage(stream=imgFile)
				createItemUtil(name,description,price,image)

# Tasks to be done at start of server
def startUpTasks():
	with app.app_context():
		# If no items exist in table, add 10
		if(len(Item.query.all())==0):
			addItems()
		# If admin doesn't exist, create
		if(not User.query.filter_by(username="admin").first()):
			createAdmin()
	logging.info(STARTUP_TASKS_COMPLETED)
startUpTasks()

# Route for home	
@app.route("/")
def home():
	token = '';
	isAdmin = '';
	try:
		# Checking if user is already in session
		if("token" in session):
			token = session["token"]
			with app.app_context():
				# Decoding token to extract userid
				data = jwt.decode(token,SECRET_KEY, algorithms=["HS256"])
				# Fetching user through user id
				user = User.query.filter_by(id=data['userId']).first()
				isAdmin = user.is_admin
		return render_template('home.jsp', token=token, isAdmin=isAdmin)
	# If token has expired
	except Exception as e:
		logging.error(str(e))
		return render_template('home.jsp', token=token, isAdmin=isAdmin)


if __name__ == '__main__':
	app.run(debug=True)