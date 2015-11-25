class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
    before_action :now, except: [:show, :edit, :update, :destroy]
    before_action :authorize
    before_action :basic  #ベーシック認証テスト
    before_action :set_i18n_lacale_from_params
    before_action :find_user
  def now
    @time=Time.zone.now.strftime("%Y年 %m月 %d日, %H:%M:%S")
  end

  private
#ベーシック認証テスト~ここから(htmlリクエストではない場合)
  def basic
    puts "==============#{request.format}========"
    unless request.format == 'text/html'
      authenticate_or_request_with_http_basic do |user, pass|
        user == 'user' && pass == 'pass'
      end
    end
  end
#ベーシック認証テスト~ここまで
# 多言語化
  def set_i18n_lacale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] =
        "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end
  def default_url_options
    {locale:I18n.locale}
  end
# 多言語化
  def find_user
    @user =User.find_by(id: session[:user_id])# ユーザー名を使えるようにする
  end
  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url,notice: "ログインしてください"
    end
  end

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart=Cart.create
    session[:cart_id]=cart.id
    cart
  end
end
