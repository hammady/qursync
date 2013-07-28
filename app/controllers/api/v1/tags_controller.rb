class Api::V1::TagsController < Api::V1::ApiController
  respond_to :json

  prepend_before_filter :create_tag, :only => :create

  # GET /tags
  def index
    render json: @tags
  end

  # GET /tags/1
  def show
    render json: @tag
  end

  # POST /tags
  def create
    save @tag
  end

  # PUT /tags/1
  def update
    save @tag
  end

  # DELETE /tags/1
  def destroy
    if @tag.destroy
      head :no_content
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  private

  def save(tag)
    if @tag.tag_name.user.id != current_user.id
      render status: :forbidden
    else
      super
    end
  end

  def create_tag
    # prepare tag object with tag_name so that cancan authorization checks correctly for the permission
    @tag = Tag.new
    @tag.tag_name = TagName.find(params[:tag_name_id])
  end

end
