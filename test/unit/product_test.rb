require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(:title       => 'My Bookish Title',
                          :description => 'yyy',
                          :image_url   => 'zzz.jpg')
    # negative price
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
    # trivial price
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01",
      product.errors[:price].join('; ')
    # valid price
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    product = Product.new(:title       => 'My Bookish Title',
                          :description => 'yyy',
                          :price       => 1,
                          :image_url   => image_url)
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.GIF FRED.JPG FRED.PNG 
             http://a.b.c/a/y/z/fred.gif }
    bad = %w{ fred.doc fred.git/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(:title       => products(:ruby).title,
                          :description => 'yyy',
                          :price       => 1,
                          :image_url   => 'fred.gif')
    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
                 product.errors[:title].join('; ')
  end
end
