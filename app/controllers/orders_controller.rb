class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy, :orders_ship, :orders_cancel]
  before_action :validar_token_api
  # GET /orders
  def index
    @orders = Order.all
    page = 1
    if params["page"].present? && params["page"].to_s.to_i > 0
      page = params["pages"]
    end
    @orders = @orders.where("school_id"=>params["school_id"]) if params["school_id"].present?
    @orders = @orders.where("status"=>params["status"]) if params["status"].present?
    @orders = @orders.paginate(:page => page, :per_page =>20)
  end

  # GET /orders/1
  def show
    if @order.nil?
      render json: {:status => "Error", :code => "400", :message => "Order not found" }, status: 400
    end
  end

  # POST /orders
  def create
    service = ValidateService::ParamsValidation.new
    permitted = params.permit(gifts: [], recipients: [])

    if service.validarOrder(permitted)
      token = request.headers["Authorization"]
      generar_orden = Order.generar_orden(permitted, token)
      if generar_orden[0]
        @order = Order.find(generar_orden[1])
        # render json: @order, status: 200, location: @order
      else
        render json: generar_orden[1], status: :unprocessable_entity
      end
    else
      invalid = service.getInvalidParamsOrder(permitted)
      render json: {:status => "Error", :code => "400", :message => "Invalid Parameters", :invalid_parameters => invalid}, status: 400
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.present?
      service = ValidateService::ParamsValidation.new
      permitted = params.permit(:status)
      if service.validarUpdateOrder(permitted)
        if @order.update(permitted)
          puts "Order updated"
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      else
        invalid = service.getInvalidParamsSchool(permitted)
        render json: {:status => "Error", :code => "400", :message => "Status #{params["status"]} is invalid", :invalid_parameters => "status"}, status: 400
      end
    else
      render json: {:status => "Error", :code => "400", :message => "Order not found" }, status: 400
    end
  end

  def orders_ship
    if @order.present?
      if @order.status == "ORDER_RECEIVED"
        @order.status = "ORDER_PROCESSING"
        @order.save
      else
        render json: {:status => "Error", :code => "400", :message => "Order status is #{@order.status}" }, status: 400
      end
    else
      render json: {:status => "Error", :code => "400", :message => "Order not found" }, status: 400
    end
  end

  def orders_cancel
    if @order.present?
      if @order.status == "ORDER_RECEIVED" || @order.status == "ORDER_PROCESSING"
        @order.status = "ORDER_CANCELLED"
        @order.save
      else
        render json: {:status => "Error", :code => "400", :message => "Order status is #{@order.status}" }, status: 400
      end
    else
      render json: {:status => "Error", :code => "400", :message => "Order not found" }, status: 400
    end
  end

  # DELETE /orders/1
  def destroy
    render json: {:status => "Error", :code => "400", :message => "Can not Delete an Order"}, status: 400
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find_by_id(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:gift_type, :recipient_id, :school_id, :status)
    end
end
