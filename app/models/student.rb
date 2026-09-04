class Student < ApplicationRecord
  STATUSES = %w[active inactive graduated].freeze

  belongs_to :user
  accepts_nested_attributes_for :user
  has_many :enrollments, dependent: :restrict_with_error
  has_many :classrooms, through: :enrollments
  has_many :student_progresses, dependent: :restrict_with_error

  scope :active, -> { where(status: "active") }

  validates :name, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :user_id, uniqueness: true
end
