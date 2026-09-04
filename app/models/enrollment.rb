class Enrollment < ApplicationRecord
  STATUSES = %w[active completed dropped].freeze

  belongs_to :student
  belongs_to :classroom

  scope :active, -> { where(status: "active") }

  validates :enrolled_at, presence: true
  validates :status, inclusion: { in: STATUSES }
  validate :no_duplicate_active_enrollment

  private

  def no_duplicate_active_enrollment
    return unless active? && student_id.present? && classroom_id.present?
    return unless Enrollment.active.where(student_id: student_id, classroom_id: classroom_id).where.not(id: id).exists?

    errors.add(:base, "student is already actively enrolled in this classroom")
  end

  def active?
    status == "active"
  end
end
