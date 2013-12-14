require 'digest/sha1'

module SecureTaggable
  def secure_tag
    Digest::SHA1.hexdigest "#{self.class.name}_#{id}_#{updated_at}"
  end
  alias_method :etag, :secure_tag
end