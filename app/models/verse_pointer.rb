class VersePointer < ActiveRecord::Base
  attr_accessible :chapter, :verse

  has_many :bookmarks, as: :pointer
  has_many :tags, as: :pointer

  validates :chapter, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 114
  }

  validates :verse, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 288
    # TODO depend on chapter, lookup limits from db, rewayat? oh!
  }

  def as_json(options = {})
    super(:only => [:chapter, :verse])
  end

end
