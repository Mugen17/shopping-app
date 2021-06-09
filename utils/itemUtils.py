from extensions import db
from model import *
from settings import *
from utils import *

# Util functions for code modularity
def createItemUtil(name):
	item = Item(name=name)
	db.session.add(item)
	db.session.commit()
	logging.info(ITEM_CREATION_SUCCESS+" for item: "+name)

def getItemsListUtil():
	items = Item.query.all()
	logging.info(RETRIEVE_ITEMS_SUCCESS)
	return items