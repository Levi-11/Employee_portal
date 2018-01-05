class AdminController < ApplicationController
  def new
    redirect_to root_path unless logged_in? && admin_logged_in?
  end
 
  def home
    redirect_to root_path unless logged_in? && admin_logged_in?
  end

  def index
    #@employee=Employee.all
    redirect_to root_path unless logged_in? && admin_logged_in?
    @employee = Employee.order("created_at DESC").paginate(page: params[:page], :per_page => 2)
  end

  def projects
    redirect_to root_path unless logged_in? && admin_logged_in?
  end

  def show
     redirect_to root_path unless logged_in? && admin_logged_in?
    @employee = Employee.find(params[:id])
  end 

  def addemployee
    redirect_to root_path unless logged_in? && admin_logged_in?
    @employee=Employee.new
  end

  def create
    @employee = Employee.new(employee_signup_params)
    if @employee.save
      # Handle a successful save.
      flash[:success] = "New employee is added!"
      redirect_to adminemployee_path
    else
      redirect_to addemployee_path
    end
  end

  def edit  
    redirect_to root_path unless logged_in? && admin_logged_in?  
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id]) 
    if @employee.update_attributes(employee_updparams) 
      flash[:success] = "Profile Updated!"
      redirect_to adminemployee_path
    else
      flash.now[:error] = "updation failed!"
      redirect_to adminedit_path
    end
  end

  private

  def employee_updparams
    params.require(:employee).permit(:name,:designation,:email,:phone,:gender,:dateofjoin,:address,:active)
  end

  def employee_signup_params
    params.require(:employee).permit(:name, :designation,:email,:phone,:gender,:dateofjoin,:dateofbirth,:active,:username,:address,:personalemail,:password,:password_confirmation)
  end
end
