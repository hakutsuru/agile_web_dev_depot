require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

  # A user goes to the index page. They select a product, adding it to their
  # cart, and check out (filling in details on the checkout form). When
  # they submit, an order is created containing their details, which
  # is associated with the line item which had been in the cart.

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    # visit index page
    get "/"
    assert_response :success
    assert_template "index"

    # select product
    xml_http_request :post, '/line_items', :product_id => ruby_book.id
    assert_response :success

    # check cart for line item
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # visit checkout
    get "/orders/new"
    assert_response :success
    assert_template "new"

    # post checkout details
    post_via_redirect "/orders",
                      :order => { :name     => "Dave Thomas",
                                  :address  => "123 The Street",
                                  :email    => "dave@example.com",
                                  :pay_type => "Check" }
    assert_response :success
    assert_template :index
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    # check order
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]
    assert_equal "Dave Thomas", order.name
    assert_equal "123 The Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type

    #check line item
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    # check notification email
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal ["depot@example.com"], mail.from
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end
end
