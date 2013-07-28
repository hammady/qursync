class Pointer < ActiveRecord::Base
  has_many :bookmarks, inverse_of: :pointer
  has_many :tags, inverse_of: :pointer
end
