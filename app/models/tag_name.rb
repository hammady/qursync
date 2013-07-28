class TagName < ActiveRecord::Base
  attr_accessible :name
  belongs_to :user, inverse_of: :tag_names
  has_many :tags
  validates :name, presence: true
  validates_uniqueness_of :name, :scope => :user_id

  def to_s
    name
  end

  def as_json(options = {})
    super(:only => [:id, :name, :created_at, :updated_at], :methods => :tags)
  end

end
