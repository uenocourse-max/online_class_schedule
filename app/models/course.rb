class Course < ApplicationRecord
  STATUSES = %w[active inactive].freeze

  has_many :classrooms, dependent: :restrict_with_error

  scope :active, -> { where(status: "active") }

  validates :name, presence: true
  validates :status, inclusion: { in: STATUSES }
end
