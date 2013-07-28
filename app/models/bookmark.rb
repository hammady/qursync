class Bookmark < ActiveRecord::Base
  attr_accessible :name, :is_default

  belongs_to :user, inverse_of: :bookmarks
  belongs_to :pointer, polymorphic: true, :dependent => :destroy
  
  validates :pointer, presence: true
  validates_associated :pointer

  after_save do |bookmark|
    if bookmark.is_default
      user = bookmark.user
      obsolete_default = user.bookmarks.find_by_is_default true
      logger.debug("Found default bookmark for user #{user.id} is #{obsolete_default.inspect}")
      if obsolete_default && obsolete_default != bookmark
        obsolete_default.is_default = false
        obsolete_default.save
      end
    end
  end

  def as_json(options = {})
    super(:only => [:id, :name, :is_default, :created_at, :updated_at], :methods => :pointer)
  end

end
