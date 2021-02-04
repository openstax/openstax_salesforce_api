class ErrorsController < ApplicationController

  def show
  end

  def unauthorized
    render '401'
  end

end
