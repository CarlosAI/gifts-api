class School < ApplicationRecord
	has_many :recipients
	has_many :orders
	belongs_to :user


	def self.validarDelete(school_id)
		salida = [true]
		existe = School.find_by_id(school_id)
		if existe.present
			recipients = Recipient.where("school_id"=>school_id).take
			if recipients.present?
				salida = [false, "Can not delete school_id #{school_id}, there are recipients associated with this school"]
			else
				orders = Order.where("status != 'ORDER_RECEIVED' or status != 'ORDER_PROCESSING' ").where("school_id"=>school_id).take
				if orders.present?
					salida = [false, "Can not delete school_id #{school_id}, there are open orders associated with this school, you must cancell them first"]
				end
			end
		else
			salida = [false, "School not found"]
		end
	end
end
