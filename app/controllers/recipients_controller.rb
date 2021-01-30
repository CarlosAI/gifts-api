class RecipientsController < ApplicationController
  before_action :set_recipient, only: [:show, :update, :destroy]
  before_action :validar_token_api

  # GET /recipients
  def index
    page = 1
    if params["page"].present? && params["page"].to_s.to_i > 0
      page = params["pages"]
    end
    @recipients = Recipient.all.select("id, name, address, school_id, (select name from schools where id=recipients.school_id) as school_name, created_at, updated_at, (select name from users where id=recipients.user_id) as created_by").order("id desc")
    @recipients = @recipients.where("school_id"=>params["school_id"]) if params["school_id"].present?
    @recipients = @recipients.paginate(:page => page, :per_page =>20)

    render json: @recipients
  end

  # GET /recipients/1
  def show
    render json: @recipient
  end

  # POST /recipients
  def create
    
    service = ValidateService::ParamsValidation.new
    permitted = params.permit(:address, :name, :school_id)

    if service.validarRecipient(permitted)
      if Recipient.where("name"=>permitted["name"], "school_id"=>permitted["school_id"]).nil?
        user = User.find_by_token(request.headers["Authorization"])
        @recipient = Recipient.new(permitted)
        @recipient.user_id = user.id
        if @recipient.save
          render json: @recipient, status: 200, location: @recipient
        else
          render json: @recipient.errors, status: :unprocessable_entity
        end
      else
        render json: {:status => "Error", :code => "400", :message => "Recipient #{params["name"]} already exists on school_id #{school_id}"}, status: 400
      end
    else
      invalid = service.getInvalidParamsRecipient(permitted)
      render json: {:status => "Error", :code => "400", :message => "Invalid Parameters", :invalid_parameters => invalid}, status: 400
    end
  end

  # PATCH/PUT /recipients/1
  def update

    service = ValidateService::ParamsValidation.new
     permitted = params.permit(:address, :name, :school_id)

    if service.validarRecipient(permitted)
      if Recipient.find_by_name(params["name"]).nil?
        if @recipient.update(permitted)
          render json: @recipient, status: 200, location: @recipient
        else
          render json: @recipient.errors, status: :unprocessable_entity
        end
      else
        render json: {:status => "Error", :code => "400", :message => "School #{params["name"]} already exists"}, status: 400
      end
    else
      invalid = service.getInvalidParamsRecipient(permitted)
      render json: {:status => "Error", :code => "400", :message => "Invalid Parameters", :invalid_parameters => invalid}, status: 400
    end
  end

  # DELETE /recipients/1
  def destroy
    can_be_deleted = Recipient.validarDelete(params[:id])
    if can_be_deleted[0]
      @recipient.destroy
      render json: {:status => "Success", :code => "200", :message => "Recipient Deleted"}, status: 200
    else
      render json: {:status => "Error", :code => "400", :message => can_be_deleted[1]}, status: 400
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recipient
      @recipient = Recipient.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def recipient_params
      params.require(:recipient).permit(:name, :address, :school_id)
    end
end
