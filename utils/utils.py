from functools import wraps
import jwt
from settings import *
from flask import request
from flask import jsonify
from model import *
import logging

# This module contains global utilities

# Logging utility
logging.basicConfig(level=logging.DEBUG)

# This decorator is used for extracting user from token
def token_required(f):
	@wraps(f)
	def decorated(*args, **kwargs):
		token = request.args.get('token')

		if(not token):
			return jsonify({'message':'Token is missing'}), 403

		try:
			# Decoding token to extract userid
			data = jwt.decode(token,SECRET_KEY, algorithms=["HS256"])
			# Fetching user through user id
			user = User.query.filter_by(id=data['userId']).first()
		except:
			return jsonify(message='Token is invalid'), 403

		return f(user, *args, **kwargs)
	return decorated