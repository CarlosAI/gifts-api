module ValidateService

	class TokenAuthentication

		def validarToken(auth_token)
			puts "Entro en validar token"
			user = User.find_by_token(auth_token)
			return user.present?
		end
	end


	class ParamsValidation
	end

end