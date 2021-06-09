from extensions import db
from model import *
from settings import *
from utils import *

# Util functions for code modularity
def addToCartUtil(cartId,itemId):
	# Fetching item from item id
	item = Item.query.filter_by(id=itemId).first()
	# Fetching cart from cart id and adding item to it
	cart = Cart.query.filter_by(id=cartId).first()
	cart.items.append(item)
	db.session.commit()
	logging.info(str(itemId)+" "+ADDITION_TO_CART_SUCCESS)
	return cart.id

def removeFromCartUtil(cartId,itemId):# Fetching item from item id
	item = Item.query.filter_by(id=itemId).first()
	# Fetching cart from cart id and removing item from it
	cart = Cart.query.filter_by(id=cartId).first()
	cart.items.remove(item)
	db.session.commit()
	logging.info(str(itemId)+" "+REMOVAL_FROM_CART_SUCCESS)
	return cart.id

def getCartItemsUtil(cartId):
	# Fetching cart from user id
	cart = Cart.query.filter_by(id=cartId).first()
	# Fetching items from cart
	items = cart.items
	logging.info(FETCH_CART_ITEMS_SUCCESS)
	return items, cart.id

def convertToOrderUtil(cartId,user):
	# Fetching cart from cart id
	cart = Cart.query.filter_by(id=cartId).first()
	# Creating and adding order from cart and user
	order = Order(cart_id=cartId,user_id=user.id)
	db.session.add(order)
	# Setting purchased boolean and removing link b/w user and cart.
	# Instead order will maintain both cart and user ids
	cart.is_purchased = True
	cart.customer = None
	# Admin does not have a cart
	if(not user.is_admin):
		# Initializing a fresh cart for the user and adding it
		newCart = Cart(customer=user)
		db.session.add(newCart)
		# Flushing to get id
		db.session.flush()
		user.cart_id = newCart.id
	db.session.commit()
	logging.info(str(cartId)+" converted to order")

def getCartsListUtil():
	# Fetching all carts
	carts = Cart.query.all()
	logging.info(FETCH_CARTS_SUCCESS)
	return carts