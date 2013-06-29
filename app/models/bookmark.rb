class Bookmark < ActiveRecord::Base
  attr_accessible :name, :page, :sura, :aya, :is_default
  belongs_to :user

  validates :name, presence: true

  validates :page, allow_blank: true, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 604
  }

  validates :sura, allow_blank: true, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 114
  }

  validates :aya, allow_blank: true, numericality: { 
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 288
    # TODO depend on sura, lookup limits from db
  }

  def self.reset_default(user, new_default)
    obsolete_default = user.bookmarks.find_by_is_default true
    logger.debug("Obsolete default bookmakr for user #{user.id} is #{obsolete_default.inspect}")
    if obsolete_default && obsolete_default != new_default
      obsolete_default.is_default = false
      obsolete_default.save
    end
  end
end
