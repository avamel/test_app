class User < ActiveRecord::Base
  rolify
  has_many :articles, dependent: :destroy
  has_many :comments
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :google_oauth2]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me,
                  :provider, :uid
  # attr_accessible :title, :body
  
  validates_presence_of :username
  validates_uniqueness_of :username
  before_create :assign_role

  def assign_role
    self.add_role :author if self.roles.first.nil?
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:uid => auth.uid).first
      if registered_user
        return registered_user
      else
        user = User.new(username:auth.extra.raw_info.name,
                        provider:auth.provider,
                        uid:auth.uid,
                        email:"#{auth.uid}@facebook.com"
                            #password:Devise.friendly_token[0,20]
                        )
        user.skip_confirmation!
        user.save!
        user.confirm!
        user
      end
    end
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
        user = User.new(username:auth.info.name,
                        provider:auth.provider,
                        uid:auth.uid,
                        email:auth.uid+"@twitter.com"
                        #password:Devise.friendly_token[0,20],
                        )
        user.skip_confirmation!
        user.save!
        user.confirm!
        user
      end
    end
  end

    def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
      if user
        return user
      else
        registered_user = User.where(:email => access_token.info.email).first
        if registered_user
          return registered_user
        else
          user = User.new(username: data["name"],
                          provider:access_token.provider,
                          email: data["email"],
                          uid: access_token.uid ,
                          #password: Devise.friendly_token[0,20],
                          )
          user.skip_confirmation!
          user.save!
          user.confirm!
          user
        end
      end
    end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
