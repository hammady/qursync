class Bookmark < ActiveRecord::Base
  include SecureTaggable

  attr_accessible :name, :is_default

  belongs_to :user, inverse_of: :bookmarks
  belongs_to :pointer, polymorphic: true, :dependent => :destroy

  validates_uniqueness_of :name, :scope => :user_id, allow_blank: true
  validates :pointer, presence: true
  validates_associated :pointer

  after_save do |bookmark|
    if bookmark.is_default
      bookmark.user.bookmarks.update_all({is_default: false}, ["id != ?", bookmark.id])
    end
  end

  def as_json(options = {})
    super(:only => [:id, :name, :is_default, :created_at, :updated_at], :methods => [:pointer, :etag])
  end

end
