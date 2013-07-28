class Api::V1::BookmarksController < Api::V1::ApiController
  respond_to :json

  # GET /bookmarks
  def index
    render json: @bookmarks
  end

  # GET /bookmarks/1
  def show
    render json: @bookmark
  end

  # POST /bookmarks
  def create
    save @bookmark
  end

  # PUT /bookmarks/1
  def update
    save @bookmark
  end

  # DELETE /bookmarks/1
  def destroy
    if @bookmark.destroy
      head :no_content
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  private

  def save(bookmark)
    bookmark.name = params[:name] unless params[:name].blank?
    bookmark.is_default = params[:is_default] == "1" unless params[:is_default].blank?
    super
  end

end
