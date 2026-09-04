class Student::ProfilesController < StudentController
  def show
    @student = current_student
  end

  def edit
    @student = current_student
  end

  def update
    @student = current_student
    if @student.update(profile_params)
      redirect_to student_profile_path, notice: "Your profile was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:student).permit(:phone, :address, :birth_date, :gender)
  end
end
