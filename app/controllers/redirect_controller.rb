class RedirectController < ApplicationController
  before_action :authenticate_user!

  def index
    if signed_in? && !current_user.is_administrator?
      redirect_to error_path
    end
  end

end
