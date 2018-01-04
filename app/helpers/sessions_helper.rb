module SessionsHelper
    # Logs in the given user.
  def log_in(employee)
    session[:employee_id] = employee.id
  end

  # Remembers a user in a persistent session.
  def remember(employee)
    employee.remember
    cookies.permanent.signed[:employee_id] = employee.id
    cookies.permanent[:remember_token] = employee.remember_token
  end  

  # Returns the user corresponding to the remember token cookie.
  def current_employee
    if (employee_id = session[:employee_id])
      @current_employee ||= Employee.find_by(id: employee_id)
    elsif (employee_id = cookies.signed[:employee_id])
      employee = Employee.find_by(id: employee_id)
      if employee && employee.authenticated?(cookies[:remember_token])
        log_in employee
        @current_employee = employee
      end
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_employee.nil?
  end

  def admin_logged_in?
    @current_employee.admin
  end
 
  # Forgets a persistent session.
  def forget(employee)
    employee.forget
    cookies.delete(:employee_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_employee)
    session.delete(:employee_id)
    @current_employee = nil
  end
end
