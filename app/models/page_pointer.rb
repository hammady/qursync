class PagePointer < ActiveRecord::Base
  attr_accessible :page

  has_many :bookmarks, as: :pointer
  has_many :notes, as: :pointer

  validates :page, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 604
  }

  def as_json(options = {})
    super(:only => :page)
  end

end
