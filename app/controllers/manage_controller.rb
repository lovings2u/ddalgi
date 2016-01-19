class ManageController < ApplicationController
	before_action :authenticate_admin_user!
	layout false, only: [:ordersheet]
	def charged
		@deposit = Order.where(:progress => 'IN PROGRESS').all
		if Date.today.between?(Date.today.beginning_of_week, Date.today.end_of_week - 3)
	      @delivery_date = Date.today.next_week(:monday)
	    else
	      @delivery_date = Date.today.next_week(:thursday)
	    end
	end
	def uncharged
		@person = Order.where(:progress => 'IN PROGRESS').all
	end
	def again
		Phone.send_message(params[:number_list],params[:message_body]).deliver_now
		redirect_to "/manage/complete"
	end
	def cancel
		@person = Order.where(:progress => 'IN PROGRESS').all
	end

	def delete
		Phone.send_message(params[:number_list],params[:message_body]).deliver_now
		index = params[:id_list].split(',')
	    index.each do |x|
	    	uncharged=Order.where(:order_index => x).take
	    	current_admin_user.cancel_last_message = params[:message_body]
	    	charged.progress == 'CANCELED'
	    	charged.save
	    end
	    redirect_to "/manage/complete"
	end

	def message

		Phone.send_message(params[:number_list],params[:message_body]).deliver_now

		index = params[:id_list].split(',')
	    index.each do |x|
	    	charged=Order.where(:order_index => x).take
	    	if charged.progress == 'IN PROGRESS'
	    		charged.progress='CHARGED'
	    		current_admin_user.charged_last_message = params[:message_body]
	    		if Date.today.between?(Date.today.beginning_of_week, Date.today.end_of_week - 3)
			      charged.delivery_date = Date.today.next_week(:monday)
			    else
			      charged.delivery_date = Date.today.next_week(:thursday)
			    end
	    	elsif charged.progress == 'CHARGED'
	    		current_admin_user.delivery_last_message = params[:message_body]
	    		charged.progress='COMPLETE'
	    	end
	    	charged.save
	    	current_admin_user.save
	    end

	    redirect_to '/manage/complete'
	end

	def delivery
		@complete = Order.where(:progress => 'CHARGED').all
	end
	def sheet_style
		@date1=Date.today.last_week(:monday)
		@date2=Date.today.last_week(:thursday)
		@date3=Date.today.beginning_of_week
		@date4=Date.today.end_of_week-3
		@date5=Date.today.next_week(:monday)
		@date6=Date.today.next_week(:thursday)

		@deliver1=Order.where(:delivery_date => @date1).count
		@deliver2=Order.where(:delivery_date => @date2).count
		@deliver3=Order.where(:delivery_date => @date3).count
		@deliver4=Order.where(:delivery_date => @date4).count
		@deliver5=Order.where(:delivery_date => @date5).count
		@deliver6=Order.where(:delivery_date => @date6).count

	end
	def ordersheet
		@complete = Order.where(:delivery_date => params[:date]).all
	end

end
