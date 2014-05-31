class Api::V1::TagsController < Api::V1::ApiController

  private

  def set_attributes(tag)
    tag.name = params[:name]
    tag.color = params[:color]
  end

end
