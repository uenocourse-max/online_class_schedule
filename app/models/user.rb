class User < ApplicationRecord
  ROLES = %w[admin teacher student].freeze

  has_secure_password

  has_one :student, dependent: :restrict_with_error
  has_one :teacher, dependent: :restrict_with_error

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: ROLES }

  ROLES.each do |role_name|
    define_method("#{role_name}?") { role == role_name }
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
