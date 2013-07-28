class Api::V1::TagNamesController < Api::V1::ApiController
  respond_to :json

  # GET /tag_names
  def index
    render json: @tag_names
  end

  # GET /tag_names/1
  def show
    render json: @tag_name
  end

  # POST /tag_names
  def create
    save @tag_name
  end

  # PUT /tag_names/1
  def update
    save @tag_name
  end

  # DELETE /tag_names/1
  def destroy
    if @tag_name.destroy
      head :no_content
    else
      render json: @tag_name.errors, status: :unprocessable_entity
    end
  end

  private

  def save(tag_name)
    tag_name.name = params[:name] unless params[:name].blank?
    super
  end

end
