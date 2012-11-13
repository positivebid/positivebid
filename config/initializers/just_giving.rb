

if Rails.env.production?
  JUSTGIVING_APP_ID = 'c3374816'
  JUSTGIVING_API_SERVER = "api.justgiving.com"
  JUSTGIVING_SERVER = "www.justgiving.com"
else
  JUSTGIVING_APP_ID = 'c0005f23'
  JUSTGIVING_API_SERVER = "api-sandbox.justgiving.com"
  JUSTGIVING_SERVER = "v3-sandbox.justgiving.com"
end

