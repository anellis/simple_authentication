class SessionController < ApplicationController
  before_action :authenticate_user, :only => [ :profile]


   def login
    if request.post?
      teacher = Teacher.find_by(email: params[:email].downcase)
      if teacher && teacher.authenticate(params[:password])
        make_session(teacher)
        redirect_to teachers_path
      else
        flash.now[:notice] = 'Invalid email/password combination'
        render 'new'
      end
    end
  end


  def profile
    if session[:teacher_id]
      redirect_to edit_teacher_path(session[:teacher_id], :password=>@current_teacher.password,:password_confirmation=>@current_teacher.password)
    else
      redirect_to new_session_path, notice: 'Please log in to see this page'
    end
  end




  def logout
    session[:teacher_id] = nil
    render 'login'
  end

  private

  def make_session(teacher)
    session[:teacher_id] = teacher.id
  end
end
