class AdminsessionController < ApplicationController
  def new 
  end

  def create
    employee = Employee.find_by(email: params[:session][:email].downcase)
    if employee && employee.authenticate(params[:session][:password])
      if employee.admin==true
      # Log the user in and redirect to the user's show page.
        log_in employee
        redirect_to adminhome_path
      else
        flash.now[:danger]="Invalid User"
        render 'new'
      end
    else
        flash.now[:danger] = 'Invalid email/password combination'
        render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to adminlogin_path
  end

end
