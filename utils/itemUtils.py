from extensions import db
from model import *
from settings import *
from utils import *

# Util functions for code modularity
def createItemUtil(name,description,price,image=None):
	if(image!=None):
		item = Item(name=name,image=image.read(),mimetype=image.mimetype,description=description,price=price)
	else:
		item = Item(name=name,image=None,mimetype=None)
	db.session.add(item)
	db.session.commit()
	logging.info(ITEM_CREATION_SUCCESS+" for item: "+name)

# Function to get all items
def getItemsListUtil(page):
	# Pagination
	paginate = Item.query.paginate(per_page=ITEMS_PER_PAGE,page=page)
	items = paginate.items
	totalPages = paginate.pages
	logging.info(RETRIEVE_ITEMS_SUCCESS)
	return items, totalPages