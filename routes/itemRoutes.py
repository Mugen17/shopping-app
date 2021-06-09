from flask import Blueprint
from extensions import db
from flask import request
from flask import jsonify
from model import *
from settings import *
from utils import *
# from itemUtils import *

# This module contains all routes relating to item
itemRoutes = Blueprint("itemRoutes",__name__, static_folder="static", template_folder="templates")

# Route for creating an item
@itemRoutes.route("/create", methods=['POST'])
def createItem():
	try:
		itemName = request.args.get('itemName')
		createItemUtil(itemName)
		# Returning all items to refresh list
		return jsonify(message=ITEM_CREATION_SUCCESS, items = getItemsListUtil()), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=ITEM_CREATION_FAILED), 500

# Route for getting all items
@itemRoutes.route("/list", methods=['GET'])
def getItemsList():
	try:
		return jsonify(message=RETRIEVE_ITEMS_SUCCESS, items=getItemsListUtil()), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=RETRIEVE_ITEMS_FAILED), 500
