require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  test "product attributes must not be empty(product属性は空であってはなりません)" do
    c_1=Product.new
    assert c_1.invalid?  #invalid?(無効かどうかtrue or false)
    # assert c_1.valid?  valid?(有効かどうかtrue or false)
    assert c_1.errors[:title].any?
    assert c_1.errors[:description].any?
    assert c_1.errors[:price].any?
    assert c_1.errors[:image_url].any?
  end

  test "product price must be positive(製品価格は正の数でなければなりません)" do
    c_2=Product.new(title:"xxx",
                    description:"yyy",
                    image_url:"zzz.png")
    c_2.price=-1
    assert c_2.invalid?
    assert_equal "must be greater than or equal to 0.01",
      c_2.errors[:price].join('; ')

    c_2.price=0
    assert c_2.invalid?
    assert_equal "must be greater than or equal to 0.01",
      c_2.errors[:price].join('; ')

    c_2.price=1     ; assert c_2.valid?
    c_2.price=0.009 ; assert c_2.invalid?
    c_2.price=0.01  ; assert c_2.valid?
  end

  def new_product(image_url)
    Product.new(title:"MybookTitle",
                description:"yyy",
                price:1,
                image_url:image_url)
  end
  test "img_url(画像のファイル形式)" do
    ok = %w{fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
            http://a.b.c/x/y/z/frea.gif }
    bad = %w{fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end

  end
  test "puroduct is not valid without a unique title(puroductは、ユニークなタイトルでないと有効ではありません)" do
    c_3=Product.new(title:products(:ruby).title,
                    description:"yyy",
                    price: 1,
                    image_url:"fred.gif")
    assert !c_3.save
    assert_equal "has already been taken",c_3.errors[:title].join('; ')
  end
end
