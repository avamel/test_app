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

  def self.find_for_facebook_oauth(auth)
    where('provider = ? and uid = ? or email = ? ', auth.provider, auth.uid, auth.info.email).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.username = auth.info.name
      user.skip_confirmation!
    end
  end 

  def self.find_for_twitter_oauth(auth)
    where('provider = ? and uid = ?', auth.provider, auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = "#{auth.uid}@twitter.com"
      user.username = auth.info.name
      user.skip_confirmation!
    end
  end

    def self.find_for_google_oauth2(auth)
      where('provider = ? and uid = ? or email = ? ', auth.provider, auth.uid, auth.info.email).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.username = auth.info.name
        user.skip_confirmation!
        end
    end


   def self.new_with_session(params, session)
     if session["devise.user_attributes"]
       new(session["devise.user_attributes"], without_protection: true) do |user|
         user.attributes = params
         user.valid?
       end
     else
       super
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
