<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">
    <link rel="stylesheet" href="../static/assets/css/styles.css">
    <script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/vee-validate@<3.0.0/dist/vee-validate.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
    <title>Shopping App</title>
  </head>
  <body>
    <div id="shoppingApp">
      <div class="loader" v-if="loading"></div>
      <nav class="navbar navbar-light bg-light mb-2">
        <div class="brand">
          <a class="navbar-brand">ShoppingApp</a>
        </div>
        <div class="options-container" v-if="loggedIn">
          <button class="btn btn-outline-primary my-1 my-sm-1" @click="showCart" v-if="!isAdmin"><i class="bi bi-cart"></i> Cart</button>
          <button class="btn btn-outline-primary my-1 my-sm-1" @click="showHistory" v-if="!isAdmin"><i class="bi bi-clock-history"></i> History</button>
          <button class="btn btn-outline-primary my-1 my-sm-1" @click="checkout" v-if="!isAdmin"><i class="bi bi-cart-check"></i> Checkout</button>
          <button class="btn btn-outline-primary my-1 my-sm-1" @click="fetchItems" v-bind:class="{'active':content=='ITEMS'}" v-if="isAdmin"><i class="bi bi-card-list"></i> Item Management</button>
          <button class="btn btn-outline-primary my-1 my-sm-1" @click="fetchCarts" v-bind:class="{'active':content=='CARTS'}" v-if="isAdmin"><i class="bi bi-cart"></i> Fetch Carts</button>
          <button class="btn btn-outline-primary my-1 my-sm-1" @click="fetchUsers" v-bind:class="{'active':content=='USERS'}" v-if="isAdmin"><i class="bi bi-person"></i> Fetch Users</button>
          <button class="btn btn-outline-primary my-1 my-sm-1" @click="fetchOrders" v-bind:class="{'active':content=='ORDERS'}" v-if="isAdmin"><i class="bi bi-clipboard-data"></i> Fetch Orders</button>
          <button class="btn btn-outline-primary my-1 my-sm-1" @click="logout">Logout</button>
        </div>
      </nav>
      <div class="login-form">
        <div v-if="!loggedIn && loginScreenBool">
          <h2 class="text-center">Log in</h2>       
          <div class="form-group mb-3">
              <input type="text" v-validate="'required|alpha_num|min:5|max:20'" class="form-control" placeholder="Username" name="username" required="required" v-model="username">
              <span>{{ errors.first('username') }}</span>
          </div>
          <div class="form-group mb-3">
              <input type="password" v-validate="'required|min:5|max:16'" class="form-control" placeholder="Password" name="password" required="required" v-model="password">
              <span>{{ errors.first('password') }}</span>
          </div>
          <div class="form-group text-center mb-3">
              <button id="loginBtn" @click="login" class="btn btn-primary btn-block">Log in</button>
          </div>      
          <p class="text-center"><a href="#" @click="toggleLoginPageBool">Create an Account</a></p>
        </div>

        <div v-if="!loggedIn && !loginScreenBool">
          <h2 class="text-center">Sign up</h2>   
          <div class="form-group mb-3">
              <input type="text" v-validate="'required|alpha|min:5|max:20'" class="form-control" placeholder="Name" name="name" required="required" v-model="name">
              <span>{{ errors.first('name') }}</span>
          </div>    
          <div class="form-group mb-3">
              <input type="text" v-validate="'required|alpha_num|min:5|max:20'" class="form-control" placeholder="Username" name="username" required="required" v-model="username">
              <span>{{ errors.first('username') }}</span>
          </div>
          <div class="form-group mb-3">
              <input type="password" v-validate="'required|min:5|max:16'" class="form-control" placeholder="Password" name="password" required="required" v-model="password">
              <span>{{ errors.first('password') }}</span>
          </div>
          <div class="form-group text-center mb-3">
              <button id="registerBtn" @click="register" class="btn btn-primary btn-block">Sign up</button>
          </div>      
          <p class="text-center"><a href="#" @click="toggleLoginPageBool">Already have an account?</a></p>
        </div>

        <div v-if="loggedIn">
          <div v-if="content=='ITEMS'">
            <h2 class="text-center">Items</h2>
            <div v-if="items.length==0" class="alert alert-info">
              <span class="text-center">No items available</span>
            </div>
            <div v-if="isAdmin">
              <ul class="list-group">
                <li v-for="item in items" class="list-group-item d-flex justify-content-between align-items-center">
                  {{item.name}}
                </li>
                <li class="bg-primary list-group-item list-group-item-action d-flex justify-content-between align-items-center" @click="content='ITEM_ADD'">
                  <span class="text-white">Add Item</span>
                </li>
              </ul>
            </div>
            <div v-if="!isAdmin">
              <ul class="list-group">
                <li v-for="item in items" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" @click="addOrRemove(item)">
                  {{item.name}}
                  <span v-if="item.added"><i class="bi bi-bag-check"></i>ADDED</span>
                </li>
              </ul>
            </div>
          </div>
          <div v-if="content=='CARTS'">
            <h2 class="text-center">Carts</h2>
            <div v-if="carts.length==0" class="alert alert-info">
              <span class="text-center">No carts available</span>
            </div>
            <ul class="list-group">
              <li v-for="cart in carts" v-if="!cart.is_purchased" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" @click="showCartDetails(cart)">
                {{cart.id}}
                <span>UserID: {{cart.user_id}}</span>
              </li>
            </ul>
          </div>
          <div v-if="content=='USERS'">
            <h2 class="text-center">Users</h2>
            <div v-if="users.length==0" class="alert alert-info">
              <span class="text-center">No users registered</span>
            </div>
            <ul class="list-group">
              <li v-for="user in users" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" @click="showUserDetails(user)">
                {{user.name}}
              </li>
            </ul>
          </div>
          <div v-if="content=='ORDERS'">
            <h2 class="text-center">ORDERS</h2>
            <div v-if="orders.length==0" class="alert alert-info">
              <span class="text-center">No orders made</span>
            </div>
            <ul class="list-group">
              <li v-for="order in orders" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" @click="showOrderDetails(order)">
                {{order.id}}
                <span>UserID: {{order.user_id}}</span>
              </li>
            </ul>
          </div>
          <div v-if="content=='ITEM_ADD'">
            <h2 class="text-center">Add Item</h2>       
            <div class="form-group mb-3">
                <input type="text" v-validate="'required'" class="form-control" placeholder="Item name" name="itemName" required="required" v-model="itemName">
                <span>{{ errors.first('itemName') }}</span>
            </div>
            <div class="form-group text-center mb-3">
                <button id="addItemBtn" @click="saveItem" class="btn btn-primary btn-block">Create Item</button>
            </div>      
          </div>
        </div>

      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>
    <script>

      Vue.use(VeeValidate);
      var vueObj = new Vue({
        el: '#shoppingApp',
        data: {
          username: null,
          password: null,
          name: null,
          // Login screen or register screen
          loginScreenBool: true,
          loggedIn: false,
          token: null,
          items: [],
          cartId: null,
          cartItems: [],
          loading: false,
          isAdmin: false,
          carts: [],
          users: [],
          orders:[],
          // To show current screen
          content: "ITEMS",
          itemName: null,
          cartItemsCount: 0
        },
        watch: {
          loggedIn: function(val){
            var vm = this;
            // When logged in, fetch items
            if(val){
              vm.fetchItems();
            }
          }
        },
        methods:{
          // To add items (logged in as admin)
          saveItem: function(){
            var vm = this;
            vm.$validator.validateAll().then((result)=>{
              if(result){
                vm.loading = true;
                axios({
                  method: 'post',
                  url: '/item/create?itemName='+vm.itemName
                }).then((response)=>{
                  vm.content = 'ITEMS';
                  vm.items = response.data.items
                },(error)=>{
                  alert(error.response.data.message)
                }).finally(()=>{
                  vm.loading = false;
                })
              }
            })
          },
          // To show details of order (logged in as admin)
          showOrderDetails: function(order){
            alertContent = "Order ID: "+order.id+"\nCart ID: "+order.cart_id+"\nUser ID: "+order.user_id;
            alert(alertContent)
          },
          // To show details of user (logged in as admin)
          showUserDetails: function(user){
            alertContent = "User ID: "+user.id+"\nName: "+user.name+"\nUsername: "+user.username+"\nRole: ";
            if(user.is_admin)
              alertContent+="Admin"
            else
              alertContent+="Customer"
            alert(alertContent)
          },
          // To show details of cart (logged in as admin)
          showCartDetails: function(cart){
            alertContent = "Cart ID: "+cart.id+"\nUser ID: "+cart.user_id+"\nItems ID(s): ";
            if(cart.items.length==0){
              alertContent+="None"
            }else{
              for(var i=0;i<cart.items.length;i++){
                alertContent+=cart.items[i].id
                if(i<cart.items.length-1)
                  alertContent+=", "
              }
            }
            alert(alertContent)
          },
          // To fetch all items (logged in as admin)
          fetchOrders: function(){
            var vm = this;
            vm.loading = true;
            axios({
              method: 'get',
              url: '/order/list'
            }).then((response)=>{
              vm.content = "ORDERS"
              vm.orders = response.data.orders
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
          },
          // To fetch all users (logged in as admin)
          fetchUsers: function(){
            var vm = this;
            vm.loading = true;
            axios({
              method: 'get',
              url: '/user/list'
            }).then((response)=>{
              vm.content = "USERS"
              vm.users = response.data.users
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
          },
          // To fetch all items
          fetchItems: function(){
            var vm = this;
            vm.items = [];
            vm.loading = true
            axios({
              method:'get',
              url: '/item/list'
            }).then((response)=>{
              for(let i=0;i<response.data.items.length;i++){
                vm.content = "ITEMS"
                // Adding flag to show if item is in cart or not
                // initializing it to false
                let item = {
                  'id': response.data.items[i].id,
                  'name': response.data.items[i].name,
                  'added': false
                }
                vm.items.push(item);
              }
              // Only making this ajax call if user is customer
              // since admin does not have a cart
              if(!isAdmin)
                // Adding flag to show if item is in cart or not
                vm.populateItems();
            },(error)=>{

            }).finally(()=>{
              vm.loading = false;
            })
          },
          // To fetch all carts of all users (logged in as admin) 
          fetchCarts: function(){
            var vm = this;
            vm.loading = true;
            axios({
              method: 'get',
              url: '/cart/list'
            }).then((response)=>{
              vm.content = "CARTS"
              vm.carts = response.data.carts
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
          },
          // To add bag icon to show items that are in cart
          populateItems: function(){
            var vm = this;
            vm.loading = true;
            vm.cartItemsCount=0;
            axios({
              method: 'get',
              url: '/cart/getItems?token='+vm.token
            }).then((response)=>{
              let items = response.data.cartItems
              vm.cartId = response.data.cartId
              for(let i=0;i<items.length;i++){
                for(let j=0;j<vm.items.length;j++){
                  if(vm.items[j].id==items[i].id){
                    // Boolean set to true to add bag icon next to item
                    vm.items[j].added = true
                    // Cart items count maintained to check if cart is empty or not
                    vm.cartItemsCount++;
                  }
                }
              }
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
          },
          // Clearing values at logout
          logout: function(){
            var vm = this;
            vm.loading = false;
            vm.username = null;
            vm.password = null;
            vm.name = null;
            vm.loginScreenBool = true;
            vm.loggedIn = false;
            vm.token = null;
            vm.items = []
            vm.cartId = null;
            vm.cartItems = [];
          },
          // To convert cart of current user into order (logged in as customer)
          checkout: function(){
            var vm = this;
            console.log(vm.cartItemsCount)
            if(vm.cartItemsCount>0){
              vm.loading = true;
              axios({
                method: 'post',
                url: '/cart/complete?token='+vm.token+'&cartId='+vm.cartId
              }).then((response)=>{
                alert(response.data.message);
                // Refreshing list of items. Not doing this on client side
                // since there might be changes to the item on server
                vm.fetchItems();
              },(error)=>{
                alert(error.response.data.message)
              }).finally(()=>{
                vm.loading = false;
              })
            }else{
              alert("Cart is empty")
            }
          },
          // To show order history of current user (logged in as customer)
          showHistory: function(){
            var vm = this;
            vm.loading = true
            axios({
              method: 'get',
              url: '/order/history?token='+vm.token
            }).then((response)=>{
              let orders = response.data.orders
              let alertContent = "Past Order ID(s): "
              if(orders.length==0)
                alertContent+="None"
              else{
                for(let i=0;i<orders.length;i++){
                  alertContent+=orders[i].id
                  if(i<orders.length-1)
                    alertContent+=", "
                }
              }
              alert(alertContent)
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
          },
          // To show cart of current user (logged in as customer)
          showCart: function(){
            var vm = this;
            vm.loading = true;
            axios({
              method: 'get',
              url: '/cart/getItems?token='+vm.token
            }).then((response)=>{
              let items = response.data.cartItems
              vm.cartId = response.data.cartId
              let alertContent = "Cart ID: "+vm.cartId+"\nItems in cart: ";
              if(items.length==0)
                alertContent+="None"
              else{
                for(let i=0;i<items.length;i++){
                  alertContent+=items[i].name
                  if(i<items.length-1)
                    alertContent+=", "
                }
              }
              alert(alertContent)
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
          },
          // To toggle each time item is clicked
          addOrRemove: function(item){
            var vm = this;
            if(item.added){
              vm.removeFromCart(item);
            }else{
              vm.addToCart(item);
            }
          },
          addToCart: function(item){
            var vm = this;
            vm.loading = true;
            axios({
              method: 'post',
              url: '/cart/add?token='+vm.token,
              data: {
                itemId: item.id
              }
            }).then((response)=>{
              vm.cartId = response.data.cartId;
              // Boolean set to true to add bag icon next to item
              item.added = true
              // Cart items count maintained to check if cart is empty or not
              vm.cartItemsCount++;
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
          },
          removeFromCart: function(item){
            var vm = this;
            vm.loading = true;
            axios({
              method: 'post',
              url: '/cart/remove?token='+vm.token,
              data: {
                itemId: item.id
              }
            }).then((response)=>{
              vm.cartId = response.data.cartId;
              // Boolean set to false to remove bag icon next to item
              item.added = false
              // Cart items count maintained to check if cart is empty or not
              vm.cartItemsCount--;
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
          },
          clearFields: function(){
            var vm = this;
            vm.name = null;
            vm.username = null;
            vm.password = null;
          },
          // Toggle switch between register and login pages
          toggleLoginPageBool: function(){
            var vm = this;
            // Reset the validator at swtich between register and login pages
            vm.$validator.reset()
            vm.loginScreenBool = !vm.loginScreenBool;
          },
          login: function(){
            var vm = this;
            vm.$validator.validateAll().then((result)=>{
              if(result){
                vm.loading = true;
                axios({
                  method: 'post',
                  url: '/user/login',
                  data: {
                    username: vm.username,
                    password: vm.password
                  }
                }).then((response)=>{
                  // Get token and boolean for whether admin or not
                  // This boolean will determine the options available
                  vm.token = response.data.token
                  vm.isAdmin = response.data.isAdmin;
                  alert(response.data.message)
                  vm.clearFields();
                  // Logged in boolean set to move to logged in screen
                  vm.loggedIn = true;
                },(error)=>{
                  alert(error.response.data.message)
                }).finally(()=>{
                  vm.loading = false;
                })
              }
            })
          },
          register: function(){
            var vm = this;
            vm.$validator.validateAll().then((result)=>{
              if(result){
                vm.loading = true;
                axios({
                  method: 'post',
                  url: '/user/create',
                  data: {
                    username: vm.username,
                    password: vm.password,
                    name: vm.name
                  }
                }).then((response)=>{
                  alert(response.data.message)
                  //Switch to log in page
                  vm.toggleLoginPageBool();
                  vm.clearFields();
                },(error)=>{
                  alert(error.response.data.message)
                }).finally(()=>{
                  vm.loading = false;
                })
              }
            })
          }
        },
        created: function(){
          var vm = this;
        }
      });
    </script>
  </body>
</html>