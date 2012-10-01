if Rails.env.production?

  GoCardless.account_details = {
    :app_id     => 'TODO',
    :app_secret => 'TODO',
    :token      => 'TODO',
  }

else

  GoCardless.account_details = {
    :app_id     => 'TODO',
    :app_secret => 'TODO',
    :token      => 'TODO',
  }

 GoCardless.environment = :sandbox

end
