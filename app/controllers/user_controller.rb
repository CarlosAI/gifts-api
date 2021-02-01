class UserController < ApplicationController

	def login
		service = ValidateService::ParamsValidation.new
		nickname = params["nickname"]
		if nickname.present? && nickname.gsub(" ","") != ""
			if service.validarEmail(params["email"])
				user = User.new
				user.name = nickname
				user.email = email
				token = SecureRandom.urlsafe_base64(nil, false)
				user.token = "APP-USER_#{token}"
				user.save
				render json: {:status => "Success", :code => "200", :message => "User Registered", :api_token => user.token}, status: 200
			else
				render json: {:status => "Error", :code => "400", :message => "email is invalid"}, status: 400
			end
		else
			render json: {:status => "Error", :code => "400", :message => "Nickname is invalid"}, status: 400
		end
	end
end
