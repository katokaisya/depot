class StoreController < ApplicationController

  def index
    @products=Product.order(:title).first(5)

    puts "デバッグ用＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝"
    puts session[:counter]
    puts "デバッグ用＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝"
    (session[:counter].nil?) ? session[:counter]=1 : session[:counter]+=1
    @counter="#{session[:counter]}回目のアクセスです。"
    @cart=current_cart    #@cartを定義
  end
end
