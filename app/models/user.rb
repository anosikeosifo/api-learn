class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  before_create(:generate_auth_token!) #this is a callback

  validates :auth_token, uniqueness: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def generate_auth_token!
  	begin
  		self.auth_token = Devise.friendly_token
  	end while self.class.exists?(auth_token: auth_token)
  	#this do-while loop structure ensures that tha token is generated if the user doesnt have any or 
  	# if the one previously generated was invalid(already in use)
  end

  has_many :products, dependent: :destroy
end
