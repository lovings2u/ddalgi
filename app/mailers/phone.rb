class Phone < ActionMailer::Base
  	def send_message msg_number,msg_body
	  	Unirest.post("http://api.openapi.io/ppurio/1/message/sms/skyhan1106",
	    headers:{:"x-waple-authorization" => "MzI4Ni0xNDQ1NjY2Nzg5OTE4LWRiZGZhOTYwLWVjNWUtNDJhZS05ZmE5LTYwZWM1ZTUyYWU5NQ=="},
	    parameters:{ 
	    :dest_phone => msg_number, 
	    :send_phone => "01027655429" , 
	    :send_name => "like ddalgi" , 
	    :msg_body =>  msg_body, 
	    :apiVersion => "1" , 
	    :id => "skyhan1106" })
	 end
end
