require 'test_helper'

class EmployeesEditTest < ActionDispatch::IntegrationTest
  def setup
    @employee = employees(:example)
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545',
      :info => {
        :personalemail => 'lvaguez@gmail.com',
        :dateofbirth => '17/04/1993'
      },
      :credentials => {
                        token: 'EAACEdEose0cBAJCbuAcrfwZCCvZCssH7oevrfoEdahTCcWcqLHx1YNZAD79gtPIV5bziXZBKSiQLXpcksEZB2Yr98R33tnXWzTyfPQdTpFevn9ZBqviZAJfdVZBa3ZAdkBHESmzUMTZBVR6CRRP8tXSvxZC5zfIRNj3W7y7QqkigcLL5g6MCS18ptWE4zyqRDnT1Y4UpVIX71E5sgZDZD',
                        secret: 'dda912d5df718404401351518ce41469'
                      }
      
    })
    stub_request(:get, /https:\/\/graph\.facebook\.com\/v2\.4\/me\?(access_token=[\S]*&)fields=id,name,about,birthday,email,picture/).
  with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.12.2'}).
  to_return(status: 200, body: {name: 'Nikhil', birthday: '10/10/1993'}.to_json, headers: {})
  end

  test "unsuccessful edit" do    
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    assert_select 'a[href=?]', auth_provider_path
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    patch employee_path(@employee), params: { employee: { 
                                              email: "foo@invalid",
                                              designation:"foo",
                                              dateofjoin:"qwe",
                                              dateofbirth:"tyu",
                                              personalemail:"foo@invalid",
                                              username:"user" } }
 
    assert @employee
  end

  test "successful edit" do  
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    assert_select 'a[href=?]', auth_provider_path

    email = "foo@bar.com"
    designation="developer",
    dateofjoin="12/11/2017",
    dateofbirth="10/12/1994",
    personalemail="foo@bar.com"
    username="foobar"
    patch employee_path(@employee), params: { employee: { 
                                              email: email,
                                              designation:designation,
                                              dateofjoin:dateofjoin,
                                              dateofbirth:dateofbirth,
                                              personalemail:personalemail,
                                              username:username } }
    assert_not flash.empty?
    assert_redirected_to home_path
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
  end

  test "facebook login success" do
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to home_path
  end

  test "facebook login not success" do
    stub_request(:get, /https:\/\/graph\.facebook\.com\/v2\.4\/me\?(access_token=[\S]*&)fields=id,name,about,birthday,email,picture/).
    with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.12.2'}).
    to_return(status: 200, body: {name: 'Nikhil'}.to_json, headers: {})
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to edit_employee_path(@employee)
  end
end