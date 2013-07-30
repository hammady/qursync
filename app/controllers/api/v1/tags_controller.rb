class Api::V1::TagsController < Api::V1::ApiController

  prepend_before_filter :create_tag, :only => :create

  private

  def set_attributes(tag)
    if @tag.tag_name.user.id != current_user.id
      render status: :forbidden
    end
  end

  def create_tag
    # prepare tag object with tag_name so that cancan authorization checks correctly for the permission
    @tag = Tag.new
    @tag.tag_name = TagName.find(params[:tag_name_id])
  end

end
