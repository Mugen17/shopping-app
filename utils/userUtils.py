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
	token = jwt.encode({'userId': user.id,'exp':datetime.datetime.utcnow()+datetime.timedelta(minutes=TOKEN_VALIDITY_MINUTES)}, SECRET_KEY)
	return token	

# Function to get list of users
def getUsersListUtil(page):
	# Pagination
	paginate = User.query.paginate(per_page=PER_PAGE,page=page)
	users = paginate.items
	totalPages = paginate.pages
	logging.info(RETRIEVE_ITEMS_SUCCESS)
	return users, totalPages

# Function to get user from user id
def getUserUtil(userId):
	user = User.query.filter_by(id=userId).first()
	logging.info(FETCH_USER_SUCCESS)
	return user