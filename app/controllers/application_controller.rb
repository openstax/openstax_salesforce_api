class ApplicationController < ActionController::API

  include AuthenticateMethods
  include ActiveJob

end
