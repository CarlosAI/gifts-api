class Order < ApplicationRecord
	belongs_to :school
	belongs_to :user
	has_many :order_details
	has_many :order_recipients

	before_create :set_status
	before_update :verificar_flag

	def set_status
		self.status = "ORDER_RECEIVED" 
		self.send_email = false
	end

	def verificar_flag
		if status == "ORDER_SHIPPED"
			self.send_email = true
			### A background proccess can be called here to send te email
		end
	end

	def self.generar_orden(permitted, token)
		params = permitted.to_h
		salida = []
		user = User.find_by_token(token)
		school_id = Recipient.find_by_id(params["recipients"][0]).school_id
		orden = Order.new
		orden.school_id = school_id
		orden.user_id = user.id
		if orden.save
			params["gifts"].each do |g|
				gift = Gift.find_by_gift_type(g)
				n_g = OrderDetail.new
				n_g.order_id = orden.id
				n_g.gift_id = gift.id
				n_g.save
			end
			params["recipients"].each do |g|
				recipient = Recipient.find_by_id(g)
				n_or = OrderRecipient.new
				n_or.order_id = orden.id
				n_or.recipient_id = recipient.id
				n_or.save
			end
			escuela = School.find_by_id(school_id)
			escuela.deliveries = escuela.deliveries + ( params["gifts"].size* params["recipients"].size)
			escuela.save
			salida = [true, orden.id]
		else
			salida = [false, orden.errors.messages]
		end
		return salida
	end
end
