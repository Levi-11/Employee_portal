class EmployeesController < ApplicationController
  
  before_action :employee_logged_in, only: [:edit,
                                            :update,
                                            :home]

  def home
    
    @employee = current_employee
  end
  
  def edit 
     
     @employee = current_employee
    #  if FACEBOOK_CONFIG.blank?
      
      if params["fb"]
        
        @user = Employee.koala(request.env['omniauth.auth']['credentials'])
        if @user['email'] || @user['birthday']
          @employee.update_attributes(personalemail: @user['email'], 
          dateofbirth: date_converter(@user['birthday']) )
          redirect_to home_path,notice: "successfully updated"
        else
          redirect_to edit_employee_path(@employee),notice: "updation failed"
        end
      else
        render 'employees/edit'
      end
  end
  
  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(employee_params)
      # Handle a successful update.
      flash[:success] = "Profile Updated successfully!"
      redirect_to home_path
    else
      flash.now[:error] = "updation failed!"
      redirect_to edit_employee_path(@employee)
    end
  end 

  def destroy
    Employee.find(params[:id]).destroy
    flash[:success] = "Employee deleted"
    redirect_to adminemployee_path
  end

  def login
    @employee = Employee.koala(request.env['omniauth.auth']['credentials'])
  end


  private

  def employee_params
    params.require(:employee).permit(:dateofbirth,:personalemail,:image)
  end
  
end
