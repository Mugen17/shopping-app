from flask import Flask, render_template
from model import *
from extensions import db
from routes import *
from settings import *
from utils import *
from passlib.hash import sha256_crypt

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
	for i in range(10):
		name = "item"+str(i)
		createItemUtil(name)
	logging.info(INITIAL_ITEMS_ADDED)

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
	return render_template('home.jsp')

if __name__ == '__main__':
	app.run(debug=True)