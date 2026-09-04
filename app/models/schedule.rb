class Schedule < ApplicationRecord
  belongs_to :classroom
  belongs_to :teacher

  validates :schedule_date, :start_time, :end_time, presence: true
  validate :end_time_after_start_time
  validate :teacher_matches_classroom

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank? || end_time > start_time

    errors.add(:end_time, "must be after start time")
  end

  def teacher_matches_classroom
    return if classroom.blank? || teacher.blank? || classroom.teacher_id == teacher_id

    errors.add(:teacher, "must match the classroom teacher")
  end
end
