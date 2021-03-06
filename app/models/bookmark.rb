class Bookmark < ActiveRecord::Base
  include SecureTaggable

  attr_accessible :name, :is_default, :color

  belongs_to :user, inverse_of: :bookmarks
  belongs_to :pointer, polymorphic: true, :dependent => :destroy
  has_and_belongs_to_many :tags

  validates_uniqueness_of :name, :scope => :user_id, allow_blank: true
  validates :pointer, presence: true
  validates_associated :pointer
  validates_with ColorValidator

  attr_accessor :new_tags

  after_save do |bookmark|
    if bookmark.is_default
      bookmark.user.bookmarks.update_all({is_default: false}, ["id != ?", bookmark.id])
    end
  end

  def attach_tags(tag_names, override, user)
    tag_names = tag_names.uniq
    if override.present?
      # clear previous tags
      self.tags.clear
    elsif self.persisted?
      # get new tags
      tag_names -= self.tags.pluck(:name)
    end
    # add tags
    self.new_tags = []
    tag_names.each do |tag_name|
      tag = Tag.where(name: tag_name, user_id: user.id).first_or_initialize
      self.new_tags << tag if tag.new_record?
      self.tags << tag
    end
  end

  def as_json(options = {})
    super(:only => [:id, :name, :is_default, :color, :created_at, :updated_at],
      :methods => [:pointer, :etag, :tag_ids, :new_tags]
    )
  end

  def tag_ids
    self.tags.map(&:id)
  end
end
