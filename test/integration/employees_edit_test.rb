require 'test_helper'

class EmployeesEditTest < ActionDispatch::IntegrationTest
  def setup
    @employee = employees(:example)
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                          :provider => 'facebook',
                                          :uid => '123545',
                                          :info => {
                                              :name => ' Example',
                                              :email => 'example@gmail.com',
                                              :birthday => '01/10/1995'
                                            },
                                            :credentials => {
                                              token: 'EAACQocJY0vUBAPTCE6GQGuQrJqmyvN78pQZBjkWs2HFjH6pnD3AkSq64N2M7ZACQaZADHeyzGhoQJNdqSuc47AydMdyfJmXrHo4ypvwCP3eYJcpf5AJzMKbI7zh0vKdOIHVXM3eU8LeWo5EQz776cDUHIVbZAgqfGfMsmLswFDMv0AR8WE84LfFLtl1W0sQZD',
                                              secret: 'ea0245ec077f79112a5be084ce5690bd'
                                            }
    })
  end

  test "unsuccessful edit" do    
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    assert_select 'a[href=?]',auth_provider_path
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
    @employee.reload 
  end

  test "successful facebook update (only birthday)" do
    stub_request(:get, /https:\/\/graph\.facebook.com\/v2\.0\/me\?(access_token=[A-Za-z0-9]*&)?fields=picture,name,email,birthday/).
    with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.12.2'}).
    to_return(status: 200, body: {birthday: '01/10/1995'}.to_json, headers: {})
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to home_path
  end

  test "successful facebook update (only email)" do
    stub_request(:get, /https:\/\/graph\.facebook.com\/v2\.0\/me\?(access_token=[A-Za-z0-9]*&)?fields=picture,name,email,birthday/).
    with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.12.2'}).
    to_return(status: 200, body: {email: 'ancy@gmail.com'}.to_json, headers: {})
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to home_path
  end

  test "successful facebook update (both email and birthday)" do
    stub_request(:get, /https:\/\/graph\.facebook.com\/v2\.0\/me\?(access_token=[A-Za-z0-9]*&)?fields=picture,name,email,birthday/).
    with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.12.2'}).
    to_return(status: 200, body: {email: 'ancy@gmail.com',birthday:'01/10/1995'}.to_json, headers: {})
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to home_path
  end

  test "invalid update with facebook" do
    stub_request(:get, /https:\/\/graph\.facebook.com\/v2\.0\/me\?(access_token=[A-Za-z0-9]*&)?fields=picture,name,email,birthday/).
    with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.12.2'}).
    to_return(status: 200, body: {name: 'Ancy'}.to_json, headers: {})
    get login_path
    post login_path, params: { session: { email:    @employee.email,
                                          password: 'password' } }
    
    get edit_employee_path(@employee)
    assert_template 'employees/edit'
    assert_select 'a[href=?]',auth_provider_path
    get auth_provider_path
    assert_redirected_to auth_facebook_callback_path
    follow_redirect!
    assert_redirected_to edit_employee_path(@employee)
  end

end