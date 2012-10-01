class UserSession < Authlogic::Session::Base

  last_request_at_threshold(1.minute)

  allow_http_basic_auth false # use http auth for other purposes

end
