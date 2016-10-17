class User < ActiveRecord::Base

  has_secure_password
  has_many :reviews, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  validates :password_digest, presence: true
  validates :password, length: {minimum: 3}
  validates :password_confirmation, length: {minimum: 3}

  def self.authenticate_with_credentials(email, password)
    # @user = User.find_by_email(email.strip)
    @user = User.where('lower(email) = ?', email.downcase.strip).first

    if @user && @user.authenticate(password)
      @user
    else
      nil
    end
  end

end
