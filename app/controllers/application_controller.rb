class ApplicationController < ActionController::Base

  include AuthenticateMethods
  include ActiveJob

end
