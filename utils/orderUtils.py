from extensions import db
from model import *
from settings import *
from utils import *

# Util functions for code modularity
def getOrderHistoryUtil(user):
	# Fetching order from user id
	orders = Order.query.filter_by(user_id=user.id)
	result = []
	for order in orders:
		result.append({'id':order.id,'cart_id':order.cart_id,'user_id':order.user_id,'created_at':order.created_at})
	logging.info(ORDER_HISTORY_FETCHED+" for user: "+str(user.id))
	return result

# Function to get all orders
def getOrdersListUtil(page):
	# Pagination
	paginate = Order.query.paginate(per_page=PER_PAGE,page=page)
	orders = paginate.items
	totalPages = paginate.pages
	logging.info(RETRIEVE_ITEMS_SUCCESS)
	return orders, totalPages