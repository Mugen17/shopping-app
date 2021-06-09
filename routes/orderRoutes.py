from flask import Blueprint
from extensions import db
from flask import jsonify
from model import *
from settings import *
from utils import *
# from orderUtils import *

# This module contains all routes relating to order
orderRoutes = Blueprint("orderRoutes",__name__, static_folder="static", template_folder="templates")

# Route for geting order history of a user
@orderRoutes.route("/history", methods=['GET'])
@token_required
def getOrderHistory(user):
	try:
		return jsonify(message=ORDER_HISTORY_FETCHED, orders=getOrderHistoryUtil(user)), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=ORDER_HISTORY_FETCH_ERROR), 500

# Route for getting all orders made by all users
@orderRoutes.route("/list", methods=['GET'])
def getOrdersList():
	try:
		return jsonify(message=FETCH_ORDERS_SUCCESS, orders=getOrdersListUtil()), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=FETCH_ORDERS_FAILED), 500
