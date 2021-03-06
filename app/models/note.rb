class Note < ActiveRecord::Base
  include SecureTaggable

  belongs_to :user, inverse_of: :notes
  belongs_to :pointer, polymorphic: true, :dependent => :destroy
  attr_accessible :text, :color

  validates :text, presence: true
  validates :pointer, presence: true
  validates_associated :pointer

  validates_with ColorValidator

  def as_json(options = {})
    super(:only => [:id, :text, :color, :created_at, :updated_at],
      :methods => [:pointer, :etag])
  end

end
