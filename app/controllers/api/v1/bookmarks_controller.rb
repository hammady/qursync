class Api::V1::BookmarksController < Api::V1::ApiController

  private

  def set_attributes(bookmark)
    bookmark.name = params[:name] unless params[:name].blank?
    bookmark.is_default = params[:is_default] == "1" unless params[:is_default].blank?
    bookmark.color = params[:color]
    # attach optional tags
    bookmark.attach_tags(params[:tags] || [], params[:override_tags], current_user)
  end

end
