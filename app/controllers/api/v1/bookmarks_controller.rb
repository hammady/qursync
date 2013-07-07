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
    @bookmark.user = current_user
    Bookmark.reset_default(current_user, @bookmark) if params[:bookmark][:is_default] == "1"

    if @bookmark.save
      render json: @bookmark, status: :created, location: @bookmark
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # PUT /bookmarks/1
  def update
    @bookmark.user = current_user
    Bookmark.reset_default(current_user, @bookmark) if params[:bookmark][:is_default] == "1"

    if @bookmark.update_attributes(params[:bookmark])
      head :no_content
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bookmarks/1
  def destroy
    if @bookmark.destroy
      head :no_content
    else
      render json: @bookmark.errors, status: :unprocessable_entity
    end
  end
end
