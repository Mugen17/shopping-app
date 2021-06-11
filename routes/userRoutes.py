from flask import Blueprint
from extensions import db
from flask import request, session
from flask import jsonify
from model import *
import datetime
from settings import *
from passlib.hash import sha256_crypt
from utils import *
# from userUtils import *

# This module contains all routes relating to user
userRoutes = Blueprint("userRoutes",__name__, static_folder="static", template_folder="templates")

# Route for creating a user
@userRoutes.route("/create", methods=['POST'])
def createUser():
	request_data = request.get_json()
	# Extracting details from request body
	name = request_data['name']
	username = request_data['username']
	password = request_data['password']
	try:
		# Checking if user with same username already exists
		existingUser = db.session.query(User).filter_by(username=username).first()
		if(not existingUser):
			createUserUtil(name,username,password,None,False)
			return jsonify(message=SUCCESSFUL_SIGNUP), 200
		else:
			logging.info(DUPLICATE_USERNAME)
			return jsonify(message=DUPLICATE_USERNAME), 400
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=DATABASE_ERROR),500

# Route for logging a user in
@userRoutes.route("/login", methods=['POST'])
def loginUser():
	request_data = request.get_json()
	# Extracting details from request body
	username = request_data['username']
	candidatePass = request_data['password']
	try:
		# Fetching user with given username
		user = db.session.query(User).filter_by(username=username).first()
		# Verifying password
		if(user and sha256_crypt.verify(candidatePass, user.password)):
			# Generating token for user
			token = generateTokenUtil(user)
			session["token"] = token
			logging.info(SUCCESSFUL_LOGIN+" for username: "+username)
			return jsonify(message=SUCCESSFUL_LOGIN, token=token, isAdmin=user.is_admin), 200
		logging.info(INVALID_CREDENTIALS_ERROR+" for username: "+username)
		return jsonify(message=INVALID_CREDENTIALS_ERROR),401
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=DATABASE_ERROR),500

# Route for logging a user in
@userRoutes.route("/logout", methods=['GET'])
def logoutUser():
	try:
		token = session["token"]
		# Decoding token to extract userid
		data = jwt.decode(token,SECRET_KEY, algorithms=["HS256"])
		# Fetching user through user id
		user = User.query.filter_by(id=data['userId']).first()
		session.pop("token",None)
		logging.info("username: "+user.username+" "+LOGGED_OUT)
		return jsonify(message=LOGGED_OUT), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=LOG_OUT_FAILED), 500


# Route for getting user from userId
@userRoutes.route("/getUser", methods=['GET'])
@token_required
def getUser(user):
	try:
		userId = request.args.get('userId')
		# Only admin should be allowed to fetch users
		if(not user.is_admin):
			return jsonify(message=UNAUTHORIZED), 401
		else:
			user = getUserUtil(userId)
			return jsonify(message=FETCH_USER_SUCCESS, user=user), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=FETCH_USER_FAILED), 500

# Route for listing all users
@userRoutes.route("/list", methods=['GET'])
def getUsersList():
	try:
		page = int(request.args.get('page'))
		users, totalPages = getUsersListUtil(page)
		return jsonify(message=RETRIEVE_USERS_SUCCESS, users=users, totalPages=totalPages), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=RETRIEVE_USERS_FAILED), 500