class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy]

  # GET /orders
  def index
    @orders = Order.all
    # @orders = Order.joins(:order_details).select("gift_id")
    # page = 1
    # if params["page"].present? && params["page"].to_s.to_i > 0
    #   page = params["pages"]
    # end
    # @orders = Order.all.select("id, school_id, (select name from schools where id=orders.school_id) as school_name, created_at, updated_at, (select name from users where id=orders.user_id) as created_by").order("id desc")
    # @orders = @orders.where("school_id"=>params["school_id"]) if params["school_id"].present?
    # @orders = @orders.where("status"=>params["status"]) if params["status"].present?
    # @orders = @orders.paginate(:page => page, :per_page =>20)
    # order_ids = @orders.pluck(:id)

    render json: @orders
  end

  # GET /orders/1
  def show
    render json: @order
  end

  # POST /orders
  def create
    @order = Order.new(order_params)

    if @order.save
      render json: @order, status: :created, location: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /orders/1
  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /orders/1
  def destroy
    @order.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def order_params
      params.require(:order).permit(:gift_type, :recipient_id, :school_id)
    end
end
