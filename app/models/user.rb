class User
  include Mongoid::Document

  attr_accessor :password

  field :email, type: String
  field :encrypt_password, type: String
  field :name, type: String

  validates :email, 
    presence: true,
    uniqueness: true
  
  validates :encrypt_password,
    presence: true

  validates :name,
    presence: true

  before_validation :put_encrypt_password
  after_save :remove_password

  def put_encrypt_password
    self.encrypt_password = BCrypt::Password.create(password)
  end

  def remove_password
    self.password = nil
  end

  def self.login(email, password)
    user = User.where(email: email).first
    if user.present?
      if BCrypt::Password.new(user.encrypt_password) == password
        user
      else
        "Wrong Password"
      end
    else
      "User Not Found"
    end
  end
end
