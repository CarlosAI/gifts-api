class Recipient < ApplicationRecord
	belongs_to :school
	belongs_to :user
	has_many :order_recipients


	def self.validarDelete(recipient_id)
		salida = [true]
		existe = Recipient.find_by_id(recipient_id)
		if existe.present?
			orders = OrderRecipient.joins(:order).where("recipient_id"=>recipient_id).where("status != 'ORDER_RECEIVED' or status != 'ORDER_PROCESSING' ").take
			if orders.present?
				salida = [false, "Can not delete recipient_id #{school_id}, there are open orders associated with this recipient_id, you must cancell them first or wait until the order be ORDER_SHIPPED"]
			end
		else
			salida = [false, "Recipient not found"]
		end
		return salida
	end
end
