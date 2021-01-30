module ValidateService

	class TokenAuthentication

		def validarToken(auth_token)
			puts "Entro en validar token"
			user = User.find_by_token(auth_token)
			return user.present?
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
	end

end