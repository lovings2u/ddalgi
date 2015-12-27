class PurchaseController < ApplicationController
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
    message = "라이크딸기청을 주문해주셔서 감사합니다!!"
    Unirest.post("http://api.openapi.io/ppurio/1/message/sms/skyhan1106",
    headers:{:"x-waple-authorization" => "MzI4Ni0xNDQ1NjY2Nzg5OTE4LWRiZGZhOTYwLWVjNWUtNDJhZS05ZmE5LTYwZWM1ZTUyYWU5NQ=="},
    parameters:{ 
    :dest_phone => od.phone_number , 
    :send_phone => "01027655429" , 
    :send_name => "like ddalgi" , 
    :subject => "주문완료" , 
    :msg_body =>  message, 
    :apiVersion => "1" , 
    :id => "skyhan1106" })

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
  def success
    buy=Customer.where(:phone_number => session[:user_id]).take
    @name=buy.name
    order=buy.orders.last
    @message_body=order.present_message
    @message_number=order.present_number
  end

  def message(phone,body)
    Unirest.post("http://api.openapi.io/ppurio/1/message/sms/skyhan1106",
    headers:{:"x-waple-authorization" => "MzI4Ni0xNDQ1NjY2Nzg5OTE4LWRiZGZhOTYwLWVjNWUtNDJhZS05ZmE5LTYwZWM1ZTUyYWU5NQ=="},
    parameters:{ 
    :dest_phone => phone , 
    :send_phone => "01027655429" , 
    :send_name => "like ddalgi" , 
    :subject => "주문완료" , 
    :msg_body =>  body, 
    :apiVersion => "1" , 
    :id => "skyhan1106" })
  end
end
