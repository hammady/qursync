class Tag < ActiveRecord::Base
  belongs_to :tag_name, inverse_of: :tags
  belongs_to :pointer, polymorphic: true, :dependent => :destroy
  
  validates :pointer, presence: true
  validates_associated :pointer

  def as_json(options = {})
    super(:only => [:id, :created_at, :updated_at, :tag_name_id], :methods => :pointer)
  end

end
