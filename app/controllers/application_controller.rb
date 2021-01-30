class ApplicationController < ActionController::API

	def validar_token_api 
		puts "entramos en validar_token_api"
		token = request.headers["HTTP_AUTHORIZATION"]
		puts token
    if token.present? 
      user = User.find_by_token(token)
      if user.nil?
      	puts "el usuario es nil"
      	render json: {:status => 403, :code => "401", :message => "Unauthorized"}, status: 401
      end 
    else
    	render json: {:status => 403, :code => "401", :message => "Unauthorized"}, status: 401
    end 
	end
end
