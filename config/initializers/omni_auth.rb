OmniAuth.config.logger = Rails.logger


# twitter account "PositiveBid"

Rails.application.config.middleware.use OmniAuth::Builder do

  if Rails.env.production?

    provider :twitter, 'TODO', 'TODO'
    provider :google_oauth2, "TODO", "TODO", {access_type: 'online', approval_prompt: ''}
    provider :facebook, 'TODO', 'TODO'

  elsif Rails.env.staging?  
    # staging.positivebid.com

    provider :twitter, 'TODO', 'TODO'
    provider :google_oauth2, "TODO", "TODO", {access_type: 'online', approval_prompt: ''}
  else 
    #development
    # provider :developer
    provider :twitter, 'TODO' , 'TODO'

    provider :google_oauth2, "TODO", "TODO", {access_type: 'online', approval_prompt: ''}

  end

end


