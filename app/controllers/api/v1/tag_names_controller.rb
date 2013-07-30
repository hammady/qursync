class Api::V1::TagNamesController < Api::V1::ApiController

  private

  def set_attributes(tag_name)
    tag_name.name = params[:name]
  end

end
