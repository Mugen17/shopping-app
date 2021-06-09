from extensions import db
from model import *
from settings import *
from utils import *
from passlib.hash import sha256_crypt
import jwt

# Util functions for code modularity
def createUserUtil(name,username,password,token,isAdmin):
	# Encrypting password
	password = sha256_crypt.encrypt(password)
	# Creating new user and adding
	user = User(name=name,username=username,password=password,token=token,cart_id=None,is_admin=isAdmin)
	db.session.add(user)
	# Admin does not have a cart
	if(not isAdmin):
		# Creating fresh cart for new user
		cart = Cart(customer=user)
		db.session.add(cart)
		# Flushing to get user id later
		db.session.flush()
		user.cart_id = cart.id
	db.session.commit()
	logging.info(SUCCESSFUL_SIGNUP+" for username: "+username)

def generateTokenUtil(user):
	token = jwt.encode({'userId': user.id,'exp':datetime.datetime.utcnow()+datetime.timedelta(minutes=30)}, SECRET_KEY)
	return token	

def getUsersListUtil():
	# Fetching all users from database
	users = User.query.all()
	logging.info(RETRIEVE_USERS_SUCCESS)
	return users