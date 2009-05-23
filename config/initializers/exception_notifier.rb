ExceptionNotifier.exception_recipients = [Enki::Config.default[:author, :email]]
ExceptionNotifier.sender_address = 
  %("Application Error" <app.error@#{URI.parse(Enki::Config.default[:url]).host}>)
