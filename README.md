# shopping-app
A basic shopping application developed using Flask and VueJs and hosted on Heroku with a MySQL database on Clever Cloud

Link to application: https://shopping-app-flask.herokuapp.com/
**Note:** If you face a database error message while logging in, please try again. This might be due to the database instance going to sleep.

## Functionalities
* Currently user can be one of two roles: Admin or Customer
* Register new user (only as Customer)
* Password saved after encrypting
* Login
* An admin user is created by default (username: admin, password: admin)
* Admin has the capability to
  * List all items
  * Add new item (items of the same name can be added)
  * List all users and view details by clicking on user
  * List all active carts and view details by clicking on cart
  * List all orders and view details by clicking on order
* Admin does not have a cart and hence can't checkout either
* Customer has the capability to
  * Add or remove item from cart by clicking on it. Currently, we are not maintaining count of items
  * View history of orders made by current user
  * View cart of current user
  * Convert current cart to an order (checkout)
* Logout 
 

## Next Steps
* Make it mobile responsive
* Add pagination for items (server side preferred)
* Maintain session on browser
* Allow for creation of more admin users
* Maker-Checker for addition of items and creation of admins
* Feature to remove item from list of items
