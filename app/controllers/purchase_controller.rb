class PurchaseController < ApplicationController
  before_action :set_cache_headers, only: [:strawberry,:confirm, :save_data, :complete]
  
  require 'unirest'
  def strawberry
    reset_session
  end

  def confirm
    find_data = Customer.where(:phone_number => params[:cell_phone]).take
    if find_data.nil?
      find_data = Customer.create!(phone_number: params[:cell_phone], name: params[:buyer_name])
      
    end
    session[:user_id] = find_data.phone_number
    od = Order.create!(progress: 'IN PROGRESS', prod_index: params[:product], prod_volume: params[:volume], prod_price: params[:total],
                  address: params[:address], detail_address: params[:detail_address], order_date: DateTime.now, 
                  customer_id: find_data.id, order_index: DateTime.now.to_s(:number), phone_number: params[:cell_phone],
                  customer_name: params[:buyer_name])
    message1 = od.customer_name + "님! 라이크딸기 딸기청을 주문해주셔서 감사합니다!! 입금 정보는"
    message2 = "신한 110-209-493870 이정석 / " + params[:message_price].to_s + "원 입니다."
    
    Phone.send_message(params[:cell_phone],message1).deliver_now
    Phone.send_message(params[:cell_phone],message2).deliver_now


    redirect_to '/purchase/save_data'
  end

  def save_data
    @b=Customer.all
    @b.each do |x|
      x.ord_count = x.orders.count
      x.ord_total = x.orders.sum(:prod_price)
      x.last_order = x.orders.reverse[0].order_date
      if x.orders.count >= 2
         x.repurchase = (x.orders.reverse[0].order_date-x.orders.reverse[1].order_date).to_i
      end
      x.save
    end
    redirect_to '/purchase/complete'
  end

  def complete
    if session[:user_id].nil?
      redirect_to '/purchase/nosession'
    else
      buy=Customer.where(:phone_number => session[:user_id]).take
      @confirm = buy.orders.last
      @username = buy.name
    end
  end

  def nosession
  end

  def present

  end
  def save_number
    if session[:user_id].nil?
      redirect_to '/purchase/nosession'
    else
      buy=Customer.where(:phone_number => session[:user_id]).take
      @confirm = buy.orders.last
      @confirm.present_message = params[:message_body]
      @confirm.present_number = params[:number_list]
      @confirm.save

      redirect_to '/purchase/success'
    end
  end
  private

  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
