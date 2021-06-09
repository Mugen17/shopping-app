from flask import Blueprint
from extensions import db
from flask import request
from flask import jsonify
from model import *
from settings import *
from utils import *
# from cartUtils import *

# This module contains all routes relating to cart
cartRoutes = Blueprint("cartRoutes",__name__, static_folder="static", template_folder="templates")

# Route for adding to cart
@cartRoutes.route("/add", methods=['POST'])
@token_required
def addToCart(user):
	try:
		request_data = request.get_json()
		itemId = request_data['itemId']
		return jsonify(message=ADDITION_TO_CART_SUCCESS, cartId=addToCartUtil(user.cart_id,itemId)), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=ADDITION_TO_CART_FAILED), 500

# Route for removing from cart
@cartRoutes.route("/remove", methods=['POST'])
@token_required
def removeFromCart(user):
	try:
		request_data = request.get_json()
		itemId = request_data['itemId']
		return jsonify(message=REMOVAL_FROM_CART_SUCCESS, cartId=removeFromCartUtil(user.cart_id,itemId)), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=REMOVAL_FROM_CART_FAILED), 500

# Route for getting all items in a cart
@cartRoutes.route("/getItems", methods=['GET'])
@token_required
def getCartItems(user):
	try:
		items, cartId = getCartItemsUtil(user.cart_id)
		return jsonify(message=FETCH_CART_ITEMS_SUCCESS, cartItems=items, cartId=cartId), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=FETCH_CART_ITEMS_FAILED), 500

# Route for converting cart to order
@cartRoutes.route("/complete", methods=['POST'])
@token_required
def convertToOrder(user):
	try:
		cartId = request.args.get('cartId')
		convertToOrderUtil(cartId,user)
		return jsonify(message=CHECKOUT_SUCCESS), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=CHECKOUT_FAILED), 500

# Route for getting all carts
@cartRoutes.route("/list", methods=['GET'])
def getCartsList():
	try:
		return jsonify(message=FETCH_CARTS_SUCCESS, carts=getCartsListUtil()), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=FETCH_CARTS_FAILED), 500