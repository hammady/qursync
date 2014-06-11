class Pointer < ActiveRecord::Base
  has_many :bookmarks, inverse_of: :pointer
  has_many :notes, inverse_of: :pointer
end
