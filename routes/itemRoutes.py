from flask import Blueprint
from extensions import db
from flask import request, send_file
from flask import jsonify, Response
from model import *
from settings import *
from utils import *
from werkzeug.datastructures import ImmutableMultiDict
import io
import base64
# from itemUtils import *

# This module contains all routes relating to item
itemRoutes = Blueprint("itemRoutes",__name__, static_folder="static", template_folder="templates")

# Route for creating an item
@itemRoutes.route("/create", methods=['POST'])
def createItem():
	try:
		image = request.files['file']
		name = dict(request.form)['name']
		description = dict(request.form)['description']
		price = float(dict(request.form)['price'])
		createItemUtil(name,description,price,image)
		# Returning all items to refresh list
		items, totalPages = getItemsListUtil(Item.query.paginate(per_page=ITEMS_PER_PAGE).pages)
		result = []
		for item in items:
			if(item.image!=None):
				obj = {
					'id':item.id,
					'name':item.name,
					'image':base64.b64encode(item.image).decode('ascii'),
					'description':item.description,
					'price':item.price,
					'mimetype':item.mimetype
				}
			else:
				obj = {
					'id':item.id,
					'name':item.name,
					'description':item.description,
					'price':item.price
				}
			result.append(obj)
		return jsonify(message=ITEM_CREATION_SUCCESS, items = result, totalPages=totalPages), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=ITEM_CREATION_FAILED), 500

# Route for getting all items
@itemRoutes.route("/list", methods=['GET'])
def getItemsList():
	try:
		page = int(request.args.get('page'))
		items, totalPages = getItemsListUtil(page)
		result = []
		for item in items:
			if(item.image!=None):
				obj = {
					'id':item.id,
					'name':item.name,
					'image':base64.b64encode(item.image).decode('ascii'),
					'description':item.description,
					'price':item.price,
					'mimetype':item.mimetype
				}
			else:
				obj = {
					'id':item.id,
					'name':item.name,
					'description':item.description,
					'price':item.price
				}
			result.append(obj)
		return jsonify(message=RETRIEVE_ITEMS_SUCCESS, items=result, totalPages=totalPages), 200
	except Exception as e:
		logging.error(str(e))
		return jsonify(message=RETRIEVE_ITEMS_FAILED), 500
