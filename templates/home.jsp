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
      <nav class="navbar navbar-light mb-2">
        <div class="brand">
          <a class="navbar-brand text-white">ShoppingApp</a>
        </div>
        <div class="options-container" v-if="loggedIn">
          <button class="btn btn-outline-light my-1 my-sm-1" @click="showCart" v-if="!isAdmin"><i class="bi bi-cart"></i> Cart</button>
          <button class="btn btn-outline-light my-1 my-sm-1" @click="showHistory" v-if="!isAdmin"><i class="bi bi-clock-history"></i> History</button>
          <button class="btn btn-outline-light my-1 my-sm-1" @click="checkout" v-if="!isAdmin"><i class="bi bi-cart-check"></i> Checkout</button>
          <button class="btn btn-outline-light my-1 my-sm-1" @click="currPage=1;fetchItems()" v-bind:class="{'active':content=='ITEMS'}" v-if="isAdmin"><i class="bi bi-card-list"></i> Item Management</button>
          <button class="btn btn-outline-light my-1 my-sm-1" @click="currPage=1;fetchCarts()" v-bind:class="{'active':content=='CARTS'}" v-if="isAdmin"><i class="bi bi-cart"></i> Fetch Carts</button>
          <button class="btn btn-outline-light my-1 my-sm-1" @click="currPage=1;fetchUsers()" v-bind:class="{'active':content=='USERS'}" v-if="isAdmin"><i class="bi bi-person"></i> Fetch Users</button>
          <button class="btn btn-outline-light my-1 my-sm-1" @click="currPage=1;fetchOrders()" v-bind:class="{'active':content=='ORDERS'}" v-if="isAdmin"><i class="bi bi-clipboard-data"></i> Fetch Orders</button>
          <button class="btn btn-outline-light my-1 my-sm-1" @click="logout">Logout</button>
        </div>
      </nav>
      <div class="login-form">
        <div v-if="!loggedIn && loginScreenBool" class="card">
          <div class="card-body">
            <h2 class="text-center">Log in</h2>       
            <div class="form-group mb-3">
                <input type="text" v-validate="'required|min:5|max:20'" class="form-control" placeholder="Username" name="username" required="required" v-model="username">
                <span class="text-danger">{{ errors.first('username') }}</span>
            </div>
            <div class="form-group mb-3">
                <input type="password" v-validate="'required|min:5|max:16'" class="form-control" placeholder="Password" name="password" required="required" v-model="password">
                <span class="text-danger">{{ errors.first('password') }}</span>
            </div>
            <div class="form-group text-center mb-3">
                <button id="loginBtn" @click="login" class="btn btn-primary btn-block">Log in</button>
            </div>      
            <p class="text-center"><a href="#" @click="toggleLoginPageBool">Create an Account</a></p>
          </div>
        </div>

        <div v-if="!loggedIn && !loginScreenBool" class="card">
          <div class="card-body">
            <h2 class="text-center">Sign up</h2>
            <div class="form-group mb-3">
                <input type="text" v-validate="'required|alpha|min:5|max:20'" class="form-control" placeholder="Name" name="name" required="required" v-model="name">
                <span class="text-danger">{{ errors.first('name') }}</span>
            </div>    
            <div class="form-group mb-3">
                <input type="text" v-validate="'required|min:5|max:20'" class="form-control" placeholder="Username" name="username" required="required" v-model="username">
                <span class="text-danger">{{ errors.first('username') }}</span>
            </div>
            <div class="form-group mb-3">
                <input type="password" v-validate="'required|min:5|max:16'" class="form-control" placeholder="Password" name="password" required="required" v-model="password">
                <span class="text-danger">{{ errors.first('password') }}</span>
            </div>
            <div class="form-group text-center mb-3">
                <button id="registerBtn" @click="register" class="btn btn-primary btn-block">Sign up</button>
            </div>      
            <p class="text-center"><a href="#" @click="toggleLoginPageBool">Already have an account?</a></p>
          </div>
        </div>
      </div>
      <div class="list-page">
        <div v-if="loggedIn" class="card list-height">
          <div class="card-body">
            <div v-if="content=='ITEMS'">
              <h2 class="text-center">Items</h2>
              <div v-if="items.length==0" class="alert alert-info">
                <span class="text-center">No items available</span>
              </div>
              <div class="container item-card mt-4 mb-4" v-for="item in items">
                <div class="d-flex justify-content-center row h-100">
                  <div class="row p-2 bg-white border rounded h-100">
                    <div class="col-md-3 mt-1 product-sub-container"><img class="img-fluid img-responsive rounded product-image" :src="item.image"></div>
                    <div class="col-md-6 mt-1">
                      <h5>{{item.name}}</h5>
                      <div class="module line-clamp">
                          <p>{{item.description}}<br><br></p>
                      </div>
                    </div>
                    <div class="align-items-center align-content-center col-md-3 border-left product-sub-container">
                      <div>
                        <div class="d-flex flex-row align-items-center justify-content-center">
                            <h4 class="mr-1">₹{{item.price}}</h4>
                        </div>
                        <button v-if="!item.added && !isAdmin" class="btn btn-outline-primary btn-sm mt-2" type="button" @click="addOrRemove(item)">Add to cart</button>
                        <button v-if="item.added && !isAdmin" class="btn btn-outline-primary btn-sm mt-2" type="button" @click="addOrRemove(item)">Remove from cart</button>
                        <button v-if="isAdmin" class="btn btn-outline-primary btn-sm mt-2" type="button" @click="showItemDetails(item)">Show Details</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="text-center" v-if="isAdmin">
                <button class="btn btn-outline-primary btn-lg mt-2" type="button" @click="content='ITEM_ADD'">Add item</button>
              </div>
            </div>
            <div v-if="content=='CARTS'">
              <h2 class="text-center">Carts</h2>
              <div v-if="carts.length==0" class="alert alert-info">
                <span class="text-center">No carts available</span>
              </div>
              <div class="container mt-4 mb-4" v-for="cart in carts">
                <div class="d-flex justify-content-center row">
                  <div class="row p-2 bg-white border rounded">
                    <div class="col-md-9 mt-2">
                      <h5><b>Cart ID: </b>{{cart.id}}</h5>
                      <h5><b>User ID: </b>{{cart.user_id}}</h5>
                    </div>
                    <div class="align-items-center align-content-center col-md-3 border-left">
                      <div class="d-flex flex-column">
                        <button class="btn btn-outline-primary btn-sm mb-1" type="button" @click="showCartDetails(cart.id)">Show Items</button>
                        <button class="btn btn-outline-primary btn-sm mb-1" type="button" @click="showUserDetailsFromId(cart.user_id)">Show User</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div v-if="content=='USERS' && isAdmin">
              <h2 class="text-center">Users</h2>
              <div v-if="users.length==0" class="alert alert-info">
                <span class="text-center">No users registered</span>
              </div>
              <div class="container mt-4 mb-4" v-for="user in users">
                <div class="d-flex justify-content-center row">
                  <div class="row p-2 bg-white border rounded">
                    <div class="col-md-9 mt-2">
                      <h5><b>User ID: </b>{{user.id}}</h5>
                      <h5><b>Name: </b>{{user.name}}</h5>
                    </div>
                    <div class="align-items-center align-content-center col-md-3 border-left mt-1">
                      <div class="d-flex flex-column">
                        <button class="btn btn-outline-primary btn-sm mb-1" type="button" @click="showUserDetails(user)">Show Details</button>
                        <button v-if="!user.is_admin" class="btn btn-outline-primary btn-sm" type="button" @click="showCartDetails(user.cart_id)">Show Cart</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div v-if="content=='ORDERS' && isAdmin">
              <h2 class="text-center">ORDERS</h2>
              <div v-if="orders.length==0" class="alert alert-info">
                <span class="text-center">No orders made</span>
              </div>
              <div class="container mt-4 mb-4" v-for="order in orders">
                <div class="d-flex justify-content-center row">
                  <div class="row p-2 bg-white border rounded">
                    <div class="col-md-9 mt-2">
                      <h5><b>Order ID: </b>{{order.id}}</h5>
                      <h5><b>User ID: </b>{{order.user_id}}</h5>
                    </div>
                    <div class="align-items-center align-content-center col-md-3 border-left mt-1">
                      <div class="d-flex flex-column">
                        <button class="btn btn-outline-primary btn-sm mb-1" type="button" @click="showUserDetailsFromId(order.user_id)">Show User</button>
                        <button class="btn btn-outline-primary btn-sm" type="button" @click="showCartDetails(order.cart_id)">Show Items</button>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div v-if="content=='ITEM_ADD'">
              <h2 class="text-center">Add Item</h2>  
              <div class="form-group mb-3">
                <span>Item Name:</span>     
                <input type="text" v-validate="'required'" class="form-control" placeholder="Item name" name="itemName" required="required" v-model="itemName"/>
                <span class="text-danger">{{ errors.first('itemName') }}</span>
              </div>
              <div class="form-group mb-3">
                <span>Item Description:</span> 
                <div class="textwrapper">
                  <textarea v-validate="'required'" name="itemDescription" cols="2" rows="4" id="rules" v-model="itemDescription"></textarea>
                  <span class="text-danger">{{ errors.first('itemDescription') }}</span>
                </div>
              </div> 
              <div class="form-group mb-3">
                <span>Item Price:</span>     
                <input type="number" v-validate="'required|min_value:1000|max_value:999999'" class="form-control" name="itemPrice" required="required" v-model="itemPrice"/>
                <span class="text-danger">{{ errors.first('itemPrice') }}</span>
              </div>
              <div class="form-group mb-3">
                  <span>Item Image:</span>    
                  <input type="file" id="file" ref="file" v-on:change="fileChange()"/>
                  <br>
                  <span class="text-danger">{{ errors.first('itemImage') }}</span>
              </div>
              <div class="form-group text-center mb-3">
                  <button id="addItemBtn" @click="saveItem" class="btn btn-primary btn-block">Create Item</button>
              </div>   
            </div>
            <div v-if="content!='ITEM_ADD' && totalPages!=null && totalPages>1" class="mt-3 text-center">
              <button :disabled="currPage<=1" class="btn btn-outline-primary my-1 my-sm-1" @click="previousPage"><i class="bi bi-arrow-left"></i></button>
                <span>Page {{ currPage }} of {{ totalPages }}</span>
              <button :disabled="currPage>=totalPages" class="btn btn-outline-primary my-1 my-sm-1" @click="nextPage"><i class="bi bi-arrow-right"></i></button>
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
          itemImage: null,
          cartItemsCount: 0,
          currPage: 1,
          totalPages: null,
          itemDescription: null,
          itemPrice: null
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
          pageFunction: function(){
            var vm = this;
            if(vm.content=='ITEMS')
              vm.fetchItems();
            if(vm.content=='ORDERS')
              vm.fetchOrders();
            if(vm.content=='USERS')
              vm.fetchUsers();
            if(vm.content=='CARTS')
              vm.fetchCarts()
          },
          previousPage: function(){
            var vm = this;
            vm.currPage--;
            vm.pageFunction();
          },
          nextPage:function(){
            var vm = this;
            vm.currPage++;
            vm.pageFunction();
          },
          fileChange: function(){
            var vm = this;
            vm.errors.remove('itemImage')
            vm.itemImage = vm.$refs.file.files[0];
          },
          // To add items (logged in as admin)
          saveItem: function(){
            var vm = this;
            vm.$validator.validateAll().then((result)=>{
              if(vm.itemImage==null || vm.itemImage.type!='image/jpeg'){
                vm.errors.add({
                  field: 'itemImage',
                  msg: '.jpg file to be added'
                });
              }
              if(result && vm.errors.items.length==0){
                vm.loading = true;
                let formData = new FormData()
                formData.append('file', vm.itemImage);
                formData.append('name',vm.itemName);
                formData.append('description',vm.itemDescription);
                formData.append('price',vm.itemPrice);
                axios.post( '/item/create',
                  formData,
                  {
                    headers: {
                        'Content-Type': 'multipart/form-data'
                    }
                  }
                ).then((response)=>{
                  vm.content = 'ITEMS';
                  vm.itemName = null;
                  vm.itemImage = null;
                  vm.itemDescription = null;
                  vm.itemPrice = null;
                  vm.totalPages = response.data.totalPages;
                  vm.currPage = vm.totalPages;
                  vm.items = [];
                  for(let i=0;i<response.data.items.length;i++){
                    let item = {
                      'id':response.data.items[i].id,
                      'name':response.data.items[i].name,
                      'description':response.data.items[i].description,
                      'price':response.data.items[i].price,
                      'image':"data:;base64,"+response.data.items[i].image,
                      'mimetype':response.data.items[i].mimetype,
                      'added':false
                    }
                    vm.items.push(item)
                  }
                },(error)=>{
                  alert(error.response.data.message)
                }).finally(()=>{
                  vm.loading = false;
                })
              }
            })
          },
          // To show details of item (logged in as admin)
          showItemDetails: function(item){
            alertContent = "Item ID: "+item.id+"\nItem Name: "+item.name+"\nItem Price: ₹"+item.price+"\nItem Description: "+item.description;
            alert(alertContent)
          },
          // To show details of order (logged in as admin)
          showOrderDetails: function(order){
            alertContent = "Order ID: "+order.id+"\nCart ID: "+order.cart_id+"\nUser ID: "+order.user_id;
            alert(alertContent)
          },
          // To show details of user from Id (logged in as admin)
          showUserDetailsFromId: function(userId){
            var vm = this;
            vm.loading = true;
            axios({
              method: 'get',
              url: '/user/getUser?userId='+userId+"&token="+vm.token
            }).then((response)=>{
              let user = response.data.user;
              vm.showUserDetails(user);
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
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
          showCartDetails: function(cartId){
            var vm = this;
            vm.loading = true;
            axios({
              method: 'get',
              url: '/cart/getItemsFromId?cartId='+cartId+"&token="+vm.token
            }).then((response)=>{
              let items = response.data.cartItems;
              let alertContent = "Items:\n";
              if(items.length>0){
                for(let i=0;i<items.length;i++){
                  alertContent+= items[i].name+"\n";
                }
              }else{
                alertContent+="None";
              }
              alert(alertContent);
            },(error)=>{
              alert(error.response.data.message)
            }).finally(()=>{
              vm.loading = false;
            })
          },
          // To fetch all orders (logged in as admin)
          fetchOrders: function(){
            var vm = this;
            vm.loading = true;
            axios({
              method: 'get',
              url: '/order/list?page='+vm.currPage
            }).then((response)=>{
              vm.content = "ORDERS"
              vm.totalPages = response.data.totalPages;
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
              url: '/user/list?page='+vm.currPage
            }).then((response)=>{
              vm.content = "USERS"
              vm.totalPages = response.data.totalPages;
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
              url: '/item/list?page='+vm.currPage
            }).then((response)=>{
              vm.totalPages = response.data.totalPages;
              vm.items = [];
              for(let i=0;i<response.data.items.length;i++){
                vm.content="ITEMS";
                let item = {
                  'id':response.data.items[i].id,
                  'name':response.data.items[i].name,
                  'description':response.data.items[i].description,
                  'price':response.data.items[i].price,
                  'image':"data:;base64,"+response.data.items[i].image,
                  'mimetype':response.data.items[i].mimetype,
                  'added':false
                }
                vm.items.push(item)
              }
              // Only making this ajax call if user is customer
              // since admin does not have a cart
              if(!vm.isAdmin)
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
              url: '/cart/list?page='+vm.currPage
            }).then((response)=>{
              vm.content = "CARTS"
              vm.totalPages = response.data.totalPages;
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
            axios({
              method: 'get',
              url: '/user/logout'
            }).then((response)=>{
            },(error)=>{
            }).finally(()=>{
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
              vm.carts = [];
              vm.users = [];
              vm.orders = [];
              vm.isAdmin = false;
              vm.content = "ITEMS";
              vm.itemName = null;
              vm.itemImage = null;
              vm.cartItemsCount = 0;
              vm.currPage = 1;
              vm.totalPages = null;
              vm.itemDescription = null;
              itemPrice = null;
              vm.loading = false;
            })
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
            vm.clearFields();
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
          let token = "%% token %%"
          let isAdmin = "%% isAdmin %%"
          if(token!="" && isAdmin!=""){
            vm.token = token;
            if(isAdmin=="True")
              vm.isAdmin = true
            else
              vm.isAdmin = false
            vm.loggedIn = true
          }
        }
      });
    </script>
  </body>
</html>