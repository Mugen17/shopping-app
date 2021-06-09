from extensions import db
from dataclasses import dataclass
import datetime

# This module contains all the models (entities) used
# The dataclass decorator allows for ease in serializing model objects

@dataclass
class Item(db.Model):
	__tablename__ = "items"

	id: int
	name: str
	created_at: datetime.datetime

	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String(255))
	created_at = db.Column(db.TIMESTAMP, default=db.func.now())
	carts = db.relationship("Cart", secondary="items_carts")

@dataclass
class Cart(db.Model):
	__tablename__ = "carts"

	id: int
	user_id: int
	is_purchased: bool	
	created_at: datetime.datetime
	items: Item

	id = db.Column(db.Integer, primary_key=True)
	user_id = db.Column(db.Integer, db.ForeignKey("users.id"), unique=True)
	is_purchased = db.Column(db.BOOLEAN, default=False)
	created_at = db.Column(db.TIMESTAMP, default=db.func.now())
	items = db.relationship("Item", secondary="items_carts")

@dataclass
class User(db.Model):
	__tablename__ = "users"

	id: int
	name: str
	username: str
	password: str
	token: str
	cart_id: int
	created_at: datetime.datetime
	is_admin: bool
	carts: Cart

	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String(255))
	username = db.Column(db.String(255), unique=True)
	password = db.Column(db.String(255))
	token = db.Column(db.String(255))
	cart_id = db.Column(db.Integer)
	created_at = db.Column(db.TIMESTAMP, default=db.func.now())
	is_admin = db.Column(db.BOOLEAN, default=False)
	carts = db.relationship('Cart', backref='customer', uselist=False)

@dataclass
class ItemCartMapping(db.Model):
	__tablename__ = "items_carts"

	id: int
	cart_id: int
	item_id: int	
	cart: Cart
	item: Item

	id = db.Column(db.Integer, primary_key=True)
	cart_id = db.Column(db.Integer, db.ForeignKey('carts.id'))
	item_id = db.Column(db.Integer, db.ForeignKey('items.id'))
	cart = db.relationship(Cart, backref=db.backref("items_carts", cascade="all, delete-orphan"))
	item = db.relationship(Item, backref=db.backref("items_carts", cascade="all, delete-orphan"))

@dataclass
class Order(db.Model):
	__tablename__ = "orders"

	id: int
	cart_id: int
	user_id: int	
	created_at: datetime.datetime

	id = db.Column(db.Integer, primary_key=True)
	cart_id = db.Column(db.Integer)
	user_id = db.Column(db.Integer)
	created_at = db.Column(db.TIMESTAMP, default=db.func.now())