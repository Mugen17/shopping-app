# shopping-app
A basic shopping application developed using Flask and VueJs and hosted on Heroku with a MySQL database on Clever Cloud

Link to application: https://shopping-app-flask.herokuapp.com/

**Note:** If you face a database error message while logging in, please try again. This might be due to the database instance going to sleep.

## Functionalities
* Currently user can be one of two roles: Admin or Customer
* Register new user (only as Customer)
* Password saved after encrypting
* Login
* Browser session maintained. User will stay logged in at refresh of page unless browser is closed or user explicitly logs out
* An admin user is created by default (username: admin, password: admin)
* 10 items are seeded by default through details from items.json
* Admin has the capability to
  * List all items
  * Add new item (items of the same name can be added)
  * List all users
    * View details of user
    * View current cart of user
  * List all active carts
    * View items in cart
    * View details of user of cart
  * List all orders
    * View items from order
    * View details of user of order
* Admin does not have a cart and hence can't checkout either
* All lists are shown paginated (server side pagination since this is a ecommerce platform and can have a lot of products)
* Items have image, description and price
* Customer has the capability to
  * Add or remove item from cart. Currently, we are not maintaining count of items
  * View history of orders made by current user
  * View cart of current user
  * Convert current cart to an order (checkout)
* Logout 

## Endpoints
* /user/create
  body contains name, username, password 
* /user/login 
* /user/logout
* /user/getUser
* /user/list
* /order/history
* /order/list
* /item/create
* /item/list
* /cart/add
* /cart/remove
* /cart/getItems
* /cart/getItemsFromId
* /cart/complete
* /cart/list -> List all carts

## Next Steps
* Make it mobile responsive
* Allow for creation of more admin users
* Maker-Checker for addition of items and creation of admins
* Feature to remove item from list of items
