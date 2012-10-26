## Depot -- Agile Web Development with Rails

Reference: "Agile Web Development with Rails (4th Edition)" for Rails 3

Walkthrough Depot application with errata and changes for using MySQL on OS X.

I did not wish to veer too much from the text (e.g. starting with Nginx/Phusion), but Homebrew and RVM are essential.
***

### Configuration

#### Xcode 4.4.1
* Command Line Tools

#### Homebrew 0.9.3
* Git 1.7.11.2
* Redis 2.4.15
* MySQL 5.5.27

#### RVM 1.15.8
* Ruby 1.9.3 (via RVM)

#### Gems
* redis
* minitest
* mysql2
* rails 3.0.17
***

## Iteration Descriptions

### Chapter 06 -- Creating the Application
#### _A1 -- Creating the Products Maintenance Application_
#### _A2 -- Making Prettier Listings_

### Chapter 07 -- Validation and Unit Testing
#### _B1 -- Validating!_
#### _B2 -- Unit Testing of Models_

### Chapter 08 -- Catalog Display
#### _C1 -- Creating the Catalog Display_
#### _C2 -- Adding a Page Layout_
#### _C3 -- Using a Helper to Format the Price_
#### _C4 -- Functional Testing of Controllers_

### Chapter 09 -- Cart Creation
#### _D1 -- Finding a Cart_
#### _D2 -- Connecting Products to Carts_
#### _D3 -- Adding a Button_

### Chapter 10 -- A Smarter Cart
#### _E1 -- Creating a Smarter Cart_
#### _E2 -- Handing Errors_
#### _E3 -- Finishing the Cart_

### Chapter 11 -- Adding a Dash of Ajax
#### _F1 -- Moving the Cart_
#### _F2 -- Creating an Ajax-Based Cart_
#### _F3 -- Highlighting Changes_
#### _F4 -- Hiding an Empty Cart_
#### _F5 -- Testing Ajax Changes_

### Chapter 12 -- Check Out!
#### _G1 -- Capturing an Order_
#### _G2 -- Atom Feeds_
#### _G3 -- Pagination_

### Chapter 13 -- Sending Mail
#### _H1 -- Sending Confirmation Emails_
#### _H2 -- Integration Testing of Applications_

### Chapter 14 -- Logging In
#### _I1 -- Adding Users_
#### _I2 -- Authenticating Users_
#### _I3 -- Limiting Access_
#### _I4 -- Adding a Sidebar, More Administration_

### Chapter 14 -- Internationalization
#### _J1 -- Selecting the Locale_
#### _J2 -- Translating the Storefront_
#### _J3 -- Translating Checkout_
#### _J4 -- Adding a Locale Switcher_

### Chapter 15 -- Deployment and Production
#### _K1 -- Deploying with Phusion Passsenger and MySQL_
#### _K2 -- Deploying Remotely with Capistrano_
#### _K3 -- Checking Up on a Deployed Application_
***

## Commits -- Observations and Detours Required

### Initialization

    rails new agile_web_dev_depot -d mysql


### Iteration A1

    rake db:create # create databases
    rake db:migrate

### Iteration A2

Copyrighted book description test data... _Seriously?_

A bit more orientation, I am _typing_ changes -- except for the seed data and css files. I want the experience of _creating_ the application, and fixing errors. Last year, when attempting to get through this, _Iteration A2_ was where the waters got rough. Perhaps the css has been tweaked, or I have become more savvy, but now, index view styling worked easily.

### Iterations B1 & B2

_No changes._

When first working through the text, I had trouble with testing, and made notes about the changes required (as found via Errata or _Stack Overflow_).

Perhaps starting off with _minitest_ installed was a mistake, I should have made a clean gemset for this project...

    # test_helper.rb

    require 'rails/test_help'
    require 'minitest' # add me

    # gemfile

    group :test do
      # Pretty printed test output
      gem 'turn', :require => false
      gem 'minitest'  # add me
    end

### Iterations C1, C2, C3 & C4

_No changes._

### Iterations D1, D2 & D3

_No changes._

### Iterations E1, E2 & E3

_No changes._

### Iteration E Playtime

Getting price into line_items table seemed important enough... And changing LineItem model to use appropriate pricing.

### Iterations F1, F2, F3, F4 & F5

_No changes... F5 iteration was added to capture testing changes, rather than appending those to F4._

### Iteration G1

Adding price to line_item (E Playtime) requires changes to order functional testing.

    # order_controllers_test.rb
    test "should get new" do
      cart = Cart.create
      session[:cart_id] = cart.id
      LineItem.create(:cart => cart,
                      :product => products(:ruby),
                      :price => products(:ruby).price)

      get :new
      assert_response :success
    end

Also, update line_items fixture to include pricing.

    # line_items.yml
    one:
      product: ruby
      price: 49.50
      order: one

    two:
      product: ruby
      price: 49.50
      cart: one

### Iteration G2

_No changes._

### Iteration G3

Iteration does not _really_ require changes, but... Sorting orders by created\_at might not give the results shown, as the generated orders may all have the same timestamp -- sort on order key to obtain the results shown in the text.

    def index
      @orders = Order.paginate :page => params[:page], :order => 'id desc',
        :per_page => 10

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @orders }
      end
    end

### Iteration H1

_No changes._

Section _Email Configuration_ is informative, but in reality, if you are relying on email (e.g. running a business) -- you should use an email marketing service. I have worked with Mad Mimi, and the assistance offered by such services is remarkable (or Mad Mimi seemed so, your mileage may differ).

### Iteration H2


Integration test fails due to mail.from match, this version works:

    # check notification email
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_equal "Pragmatic Store Order Confirmation", mail.subject

### Iterations I1 & I2

_No changes._
