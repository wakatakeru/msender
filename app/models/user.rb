class User < ApplicationRecord
  has_secure_password

  validates :login_id,
            :presence => true,
            :uniqueness => true,
            :format => { :with => /\A[a-z0-9]+\z/i }

  validates :password,
            :presence => true,
            :confirmation => true,
            :format => { :with => /\A[a-z0-9]+\z/i },
            :on => :create

  def validate_password?
    password.presence? || password_confirmation.presence?
  end
end
