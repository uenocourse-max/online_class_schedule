class Classroom < ApplicationRecord
  STATUSES = %w[active inactive completed].freeze

  belongs_to :course
  belongs_to :teacher
  has_many :enrollments, dependent: :restrict_with_error
  has_many :students, through: :enrollments
  has_many :schedules, dependent: :restrict_with_error
  has_many :student_progresses, dependent: :restrict_with_error

  scope :active, -> { where(status: "active") }

  validates :name, presence: true
  validates :status, inclusion: { in: STATUSES }
end
