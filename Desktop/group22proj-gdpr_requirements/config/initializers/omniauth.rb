Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '819553698629-l6si7qgfgmipot13kjkme8v5m036esq1.apps.googleusercontent.com', '-CjK93DhXCVehLmSby116B4B', scope: 'userinfo.profile,youtube', skip_jwt: true
end
