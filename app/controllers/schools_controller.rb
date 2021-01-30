class SchoolsController < ApplicationController
  before_action :set_school, only: [:show, :update, :destroy]
  before_action :validar_token_api

  # GET /schools
  def index
    page = 1
    if params["page"].present? && params["page"].to_s.to_i > 0
      page = params["pages"]
    end
    @schools = School.all
    @schools = @schools.order(id: :desc).paginate(:page => page, :per_page =>20)
    render json: @schools, status: 200
  end

  # GET /schools/1
  def show
    render json: @school
  end

  # POST /schools
  def create
    service = ValidateService::ParamsValidation.new
    permitted = params.permit(:address, :name)
    if service.validarSchool(permitted)
      if School.find_by_name(params["name"]).nil?
        user = User.find_by_token(request.headers["Authorization"])
        @school = School.new(permitted)
        @school.user_id = user.id
        if @school.save
          render json: @school, status: 200, location: @school
        else
          render json: @school.errors, status: :unprocessable_entity
        end
      else
        render json: {:status => "Error", :code => "400", :message => "School #{params["name"]} already exists"}, status: 400
      end
    else
      invalid = service.getInvalidParamsSchool(permitted)
      render json: {:status => "Error", :code => "400", :message => "Invalid Parameters", :invalid_parameters => invalid}, status: 400
    end
    
  end

  # PATCH/PUT /schools/1
  def update
    service = ValidateService::ParamsValidation.new
    permitted = params.permit(:address, :name)
    if service.validarSchool(permitted)
      if School.find_by_name(params["name"]).nil?
        if @school.update(permitted)
          render json: @school, status: 200, location: @school
        else
          render json: @school.errors, status: :unprocessable_entity
        end
      else
        render json: {:status => "Error", :code => "400", :message => "School #{params["name"]} already exists"}, status: 400
      end
    else
      invalid = service.getInvalidParamsSchool(permitted)
      render json: {:status => "Error", :code => "400", :message => "Invalid Parameters", :invalid_parameters => invalid}, status: 400
    end
  end

  # DELETE /schools/1
  def destroy
    can_be_deleted = School.validarDelete(params[:id])
    if can_be_deleted[0]
      @school.destroy
      render json: {:status => "Success", :code => "200", :message => "School Deleted"}, status: 200
    else
      render json: {:status => "Error", :code => "400", :message => can_be_deleted[1]}, status: 400
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def school_params
      params.require(:school).permit(:name, :address)
    end
end
