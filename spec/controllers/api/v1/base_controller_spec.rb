require 'rails_helper'
require 'swagger_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  controller(Api::V1::BaseController) do
    def standard_error
      raise StandardError
    end

    def cannot_find_user_contact
      raise CannotFindUserContact
    end

    def bad_request
      raise BadRequest
    end

    def not_authorized
      raise NotAuthorized
    end
  end

  it '#standard_error' do
    routes.draw { get 'standard_error' => 'api/v1/base#standard_error' }

    request.headers.merge! set_cookie
    expect { get :standard_error }.to raise_error(StandardError)
  end

  it '#bad_request' do
    routes.draw { get 'bad_request' => 'api/v1/base#bad_request' }

    request.headers.merge! set_cookie
    expect { get :bad_request }.to raise_error(BadRequest)
  end

  it '#cannot_find_user_contact' do
    routes.draw { get 'cannot_find_user_contact' => 'api/v1/base#cannot_find_user_contact' }

    request.headers.merge! set_cookie
    expect { get :cannot_find_user_contact }.to raise_error(CannotFindUserContact)
  end

  it '#not_authorized' do
    routes.draw { get 'not_authorized' => 'api/v1/base#not_authorized' }

    request.headers.merge! set_cookie
    expect { get :not_authorized }.to raise_error(NotAuthorized)
  end
end