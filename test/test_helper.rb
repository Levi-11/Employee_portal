require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
ENV['RAILS_ENV'] ||= 'test'
OmniAuth.config.test_mode = true
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:employee_id].nil?
  end

  # Log in as a particular user.
  def log_in_as(employee)
    session[:employee_id] = employee.id
  end

  def is_admin_logged_in?(admin)
    !!admin.admin
  end

  
end

class ActionDispatch::IntegrationTest
  
    # Log in as a particular user.
    def log_in_as(employee, password: 'password', remember_me: '1')
      post login_path, params: { session: { email: employee.email,
                                            password: password,
                                            remember_me: remember_me } }
    end

end
  