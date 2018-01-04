class EmployeesController < ApplicationController

  def home
    redirect_to root_path unless logged_in? && !admin_logged_in?
  end
  
  def edit 
     redirect_to root_path unless logged_in? && !admin_logged_in?
     @employee = current_employee
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

  private

  def employee_params
    params.require(:employee).permit(:dateofbirth,:personalemail,:image)
  end
  
end
