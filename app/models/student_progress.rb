class StudentProgress < ApplicationRecord
  STATUSES = %w[excellent good needs_improvement poor completed].freeze

  belongs_to :student
  belongs_to :classroom
  belongs_to :teacher

  validates :progress_date, :score, presence: true
  validates :score, numericality: { in: 0..100 }
  validates :status, inclusion: { in: STATUSES }
  validate :student_is_enrolled
  validate :teacher_matches_classroom

  private

  def student_is_enrolled
    return if student.blank? || classroom.blank?
    return if Enrollment.where(student_id: student_id, classroom_id: classroom_id, status: %w[active completed]).exists?

    errors.add(:student, "must be enrolled in the classroom")
  end

  def teacher_matches_classroom
    return if classroom.blank? || teacher.blank? || classroom.teacher_id == teacher_id

    errors.add(:teacher, "must match the classroom teacher")
  end
end
