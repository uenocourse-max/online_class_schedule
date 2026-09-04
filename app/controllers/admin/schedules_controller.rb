class Admin::SchedulesController < AdminController
  before_action :set_schedule, only: %i[show edit update destroy]

  def index
    @schedules = Schedule.includes(:classroom, :teacher).order(schedule_date: :asc, start_time: :asc)
  end

  def show; end
  def new
    @schedule = Schedule.new(schedule_date: Date.current)
    load_options
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      redirect_to admin_schedule_path(@schedule), notice: "Schedule created successfully."
    else
      load_options
      render :new, status: :unprocessable_entity
    end
  end

  def edit; load_options; end

  def update
    if @schedule.update(schedule_params)
      redirect_to admin_schedule_path(@schedule), notice: "Schedule was successfully updated."
    else
      load_options
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule.destroy!
    redirect_to admin_schedules_path, notice: "Schedule was deleted."
  end

  private
  def set_schedule; @schedule = Schedule.find(params[:id]); end
  def load_options
    @classrooms = Classroom.active.order(:name)
    @teachers = Teacher.active.order(:name)
  end
  def schedule_params; params.require(:schedule).permit(:classroom_id, :teacher_id, :schedule_date, :start_time, :end_time, :room, :meeting_link); end
end
