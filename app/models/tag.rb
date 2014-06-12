class Tag < ActiveRecord::Base
  include SecureTaggable

  attr_accessible :name, :color
  belongs_to :user, inverse_of: :tags
  has_and_belongs_to_many :bookmarks
  
  validates :name, presence: true
  validates_uniqueness_of :name, :scope => :user_id
  validates_with ColorValidator

  def to_s
    name
  end

  def as_json(options = {})
    super(:only => [:id, :name, :color, :created_at, :updated_at],
      :methods => [:pointer, :etag, :bookmark_ids]
    )
  end

  def bookmark_ids
    self.bookmarks.map(&:id)
  end

end
