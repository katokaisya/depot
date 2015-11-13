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
    c_2=Product.new(title:"xxx123456789",
                    description:"yyy",
                    image_url:"zzz.png")
    c_2.price=-1
    assert c_2.invalid?
    assert_equal "は0.01以上の値にしてください",#must be greater than or equal to 0.01
      c_2.errors[:price].join('; ')

    c_2.price=0
    assert c_2.invalid?
    assert_equal "は0.01以上の値にしてください",#must be greater than or equal to 0.01
      c_2.errors[:price].join('; ')

    c_2.price=1     ; assert c_2.valid?
    c_2.price=0.009 ; assert c_2.invalid?
    c_2.price=0.01  ; assert c_2.valid?
  end

  def new_product(image_url)
    Product.new(title:"MybookTitle1234567",
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

  test "product title legth is so long (product長)" do
    c_4=products(:ruby)
    c_4.title="12345678910"
    assert c_4.valid?
  end

  test "title minimum 10 characters" do
    product = products(:ruby)

    product.title = "123456789"
    assert product.invalid?
    assert product.errors[:title].join(";").include?("文字以上")

    product.title = "あいうえおかきくけ"
    assert product.invalid?

    product.title = "1234567890"
    assert product.valid?

    # 全てが半角スペースの時は「空っぽ扱い」らしいよ！
    product.title = "          "
    assert product.invalid?, "#{product.title.size} characters"
    assert product.errors[:title].join(";").include?("を入力してください")

    # 全てが全角スペースの時も「空っぽ扱い」らしいよ！
    product.title = "　　　　　　　　　　"
    assert product.invalid?, "#{product.title.size} characters"

    # 1文字でもスペース以外が含まれていたらvalidらしいよ！
    product.title = "1         "
    assert product.valid?, "#{product.title.size} characters"
  end

end
