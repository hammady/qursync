class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable, #:confirmable, #:recoverable,
    :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook, :twitter]  # :google_oauth2

  attr_accessible :email, :password, :password_confirmation, :remember_me

  attr_accessible :provider, :uid, :name

  has_many :bookmarks, inverse_of: :user
  has_many :tag_names, inverse_of: :user
  has_many :tags, through: :tag_names
  has_many :notes, inverse_of: :user

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  # def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
  #   data = access_token.info
  #   user = User.where(:email => data["email"]).first

  #   unless user
  #       user = User.create(name: data["name"],
  #            email: data["email"],
  #            password: Devise.friendly_token[0,20]
  #           )
  #   end
  #   user
  # end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                           )
    end
    user
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil) 
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.uid + "@twitter.com").first
      if registered_user
        return registered_user
      else
        user = User.create(name:auth.info.name,
          provider:auth.provider,
          uid:auth.uid,
          email:auth.uid+"@twitter.com",
          password:Devise.friendly_token[0,20],
        )
      end
    end
  end
end
