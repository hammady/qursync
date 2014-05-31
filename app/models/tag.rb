class Tag < ActiveRecord::Base
  include SecureTaggable

  attr_accessible :name
  belongs_to :user, inverse_of: :tags
  belongs_to :pointer, polymorphic: true, :dependent => :destroy
  
  validates :name, presence: true
  validates :pointer, presence: true
  validates_associated :pointer

  def to_s
    name
  end

  def as_json(options = {})
    super(:only => [:id, :name, :created_at, :updated_at],
      :methods => [:pointer, :etag])
  end

end
