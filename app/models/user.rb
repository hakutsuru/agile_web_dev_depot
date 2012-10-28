require 'bcrypt'

class User < ActiveRecord::Base
  PASSWORD_MIN_LENGTH = 6
  PASSWORD_MAX_LENGTH = 42
  after_destroy :ensure_an_admin_remains
  validates :name, :presence => true, :uniqueness => true

  validates :password, :confirmation => true
  validates_length_of :password,
                      :minimum => PASSWORD_MIN_LENGTH, 
                      :maximum => PASSWORD_MAX_LENGTH
  attr_accessor :password_confirmation
  attr_reader :password

  validate :password_must_be_present

  def ensure_an_admin_remains
    if User.count.zero?
      raise "Can't delete last user"
    end
  end

  def User.authenticate(name, password)
    if password.length < PASSWORD_MAX_LENGTH
      if user = find_by_name(name)
        if BCrypt::Password.new(user.hashed_password) == password
          user
        end
      end
    end
  end

  def User.encrypt_password(password)
    # beware, *not* idempotent (includes salt)
    BCrypt::Password.create(password)
  end

  # 'password' is a virtual attribute
  def password=(password)
    @password = password
    if password.present?
      self.hashed_password = self.class.encrypt_password(password)
    end
  end

  private

  def password_must_be_present
    errors.add(:password, "Missing password") unless hashed_password.present?
  end
end
