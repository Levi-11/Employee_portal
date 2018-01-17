class AdminController < ApplicationController

  before_action :admin_logged_in, only: [:home, 
                                         :index, 
                                         :addemployee, 
                                         :show, 
                                         :projects,
                                         :edit,
                                         :update,
                                         :new]
  def new
    
  end
 
  def home
    
  end

  def index
    #@employee=Employee.all
    
    @employee = Employee.order("created_at DESC").paginate(page: params[:page], :per_page => 2)
  end

  def projects
    
  end

  def show
     
    @employee = Employee.find(params[:id])
  end 

  def addemployee
    
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_signup_params)
    if @employee.save
      # Handle a successful save.
      flash[:success] = "New employee is added!"
      redirect_to adminemployee_path
    else
      render 'addemployee'
    end
  end

  def edit  
      
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
