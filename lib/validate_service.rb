module ValidateService

	class UserAuthentication

		def validarEmail(email)
			valid = false
			if !(email =~ URI::MailTo::EMAIL_REGEXP).nil?
				valid = true
			end
		end
	end


	class ParamsValidation

		def validarSchool(permitted)
			valid = false
			if permitted.present? && permitted.permitted?
				params = permitted.to_h
				valid = true if params["address"].present? && params["address"].to_s.gsub(" ","") != "" && params["name"].present? && params["name"].to_s.gsub(" ","") != ""
			end
			return valid
		end

		def validarRecipient(permitted)
			valid = false
			if permitted.present? && permitted.permitted?
				params = permitted.to_h
				valid = true if params["address"].present? && params["address"].to_s.gsub(" ","") != "" && params["name"].present? && params["name"].to_s.gsub(" ","") != ""
				if params["school_id"].present? && params["school_id"].to_s.gsub(" ","") != ""
					valid = false if School.find_by_id(params["school_id"].to_s.to_i).nil?
				else
					valid = false
				end
			end
			return valid
		end

		def getInvalidParamsRecipient(permitted)
			salida = []
			if permitted.present? && permitted.permitted?
				params = permitted.to_h
				salida << "address" if params["address"].nil? || params["address"].to_s.gsub(" ","") == ""
				salida << "name" if params["name"].nil? || params["name"].to_s.gsub(" ","") == ""
				if params["school_id"].nil? || params["school_id"].to_s.gsub(" ","") == ""
					salida << "school_id"
				else
					salida << "None school was found with school_id #{school_id}" if School.find_by_id(params["school_id"].to_s.to_i).nil?
				end
			else
				salida = ["address", "name", "school_id"]
			end
			return salida
		end

		def getInvalidParamsSchool(permitted)
			salida = []
			if permitted.present? && permitted.permitted?
				params = permitted.to_h
				salida << "address" if params["address"].nil? || params["address"].to_s.gsub(" ","") == ""
				salida << "name" if params["name"].nil? || params["name"].to_s.gsub(" ","") == ""
			else
				salida = ["address", "name"]
			end
			return salida
		end

		def validarOrder(permitted)
			valid = false
			if permitted.present? && permitted.permitted?
				params = permitted.to_h
				if params["gifts"].size > 0 && params["recipients"].size > 0
					existen = true
					params["gifts"].each do |g|
						if Gift.find_by_gift_type(g).nil?
							existen = false
						end
					end
					if existen
						existen_r = true
						params["recipients"].each do |g|
							if Recipient.find_by_id(g).nil?
								existen_r = false
							end
						end
						if existen_r
							if params["recipients"].uniq.size == params["recipients"].size
								if params["recipients"].size <= 20
									same_school = Recipient.where("id in (?)", params["recipients"]).pluck(:school_id).uniq
									if same_school.size == 1
										envios = params["recipients"].size * params["gifts"].size
										gifts_enviados = self.validar_limite_ordenes(same_school)
										if gifts_enviados + envios <= 60
											valid = true
										end
									end
								end
							end
						end
					end
				end
			end
			return valid
		end

		def getInvalidParamsOrder(permitted)
			valid = false
			salida = []
			if permitted.present? && permitted.permitted?
				params = permitted.to_h
				puts "van params"
				puts params
				if params["gifts"].size > 0 && params["recipients"].size > 0
					existen = true
					params["gifts"].each do |g|
						if Gift.find_by_gift_type(g).nil?
							existen = false
						end
					end
					if existen
						existen_r
						params["recipients"].each do |g|
							if Recipient.find_by_id(g).nil?
								existen_r = false
							end
						end
						if existen_r
							if params["recipients"].uniq.size == params["recipients"].size
								if params["recipients"].size <= 20
									same_school = Recipient.where("id in (?)", params["recipients"]).pluck(:school_id).uniq
									if same_school.size == 1
										envios = params["recipients"].size * params["gifts"].size
										gifts_enviados = self.validar_limite_ordenes(same_school)
										if gifts_enviados + envios > 60
											salida << "Limit of 60 gifts per day reached for the school #{escuela.name}"
										end
									else
										salida << "The Recipients belong to different schools"
									end
								else
									salida << "Limit number of recipients reached, maximun number allowed is 20"
								end
							else
								repetidos = self.list_duplicates(params["recipients"])
								salida << "The next recipients are duplicated: #{repetidos}"
							end
						else
							params["recipients"].each do |g|
								salida << "recipient id #{g} not found" if Recipient.find_by_id(g).nil?
							end
						end
					else
						params["gifts"].each do |g|
							salida << "gift #{g} is invalid" if Gift.find_by_gift_type(g).nil?
						end
					end
				else
					salida << ["gifts must be present"]
				end
			else
				salida << ["gifts and recipient must be present"]
			end
			return salida
		end

		def self.list_duplicates(array)
		  duplicates = array.select { |e| array.count(e) > 1 }
		  duplicates.uniq
		end

		def self.validar_limite_ordenes(school_id)
			date = Time.now.in_time_zone("Mexico City").to_date
			ordenes = Order.where(:created_at => date.beginning_of_day..date.end_of_day)
			gifts_enviados = 0
			ordenes.each do |x|
				gifts = OrderDetail.where("order_id"=>x.id).count
				recipients = OrderRecipient.where("order_id"=>x.id).count
				gifts_enviados = gifts_enviados + (gifts * recipients)
			end
			return gifts_enviados
		end

		def validarUpdateOrder(permitted)
			valid = false
			if permitted.present? && permitted.permitted?
				params = permitted.to_h
				allowed = ["ORDER_RECEIVED", "ORDER_PROCESSING", "ORDER_SHIPPED", "ORDER_CANCELLED"]
				if allowed.include?(params["status"])
					valid = true
				end
			end
			return valid
		end

	end

end