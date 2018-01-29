Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'], 
            scope: 'user_about_me,email,user_birthday,user_hometown,user_location,user_posts'
  #           strategy_class: OmniAuth::Strategies::Facebook,
  #           {provider_ignores_state: true}
end
  