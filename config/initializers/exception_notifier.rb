Enki::Application.config.middleware.use ExceptionNotifier,
  :ignore_exceptions    => [ActionController::InvalidAuthenticityToken],
  :email_prefix         => "[Enki] ",
  :sender_address       => "0xff.me@0xff.me",
  :exception_recipients => [Enki::Config.default[:author, :email]]
