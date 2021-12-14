# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://salesforce.openstax.org',
          variables: {
            defaultHost: {
              default: 'salesforce.openstax.org'
            }
          }
        }
      ],
      securityDefinitions: {
        apiToken: {
          description: 'OpenStax SSO Cookie needed for API Calls',
          type: :apiKey,
          name: 'HTTP_COOKIE',
          in: :header
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json

  def oxa_cookie
    'oxa_dev=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..oJ_QTvZMOu_vpKhn.5y7Ogi3MjK3sfBBAJx2XvWmt_2uInWr0wQpozh2eviaWZNbRNEifsBvcLCrsCfKU2kU4t8jpIH0CinGEVoqe4vt3uTlqz2nQaVkpdR3VrWG4JGmEe1v5gxU6JKcrJdM7sbJFpgFb0g-hKJ_fqVmuTEJSrGsn6UmcLWFtT1rwX2WrIYtjh64bzwoR_z5dtI56E70CAZrnd-L_UV91QpfwDUHhD_lcFD6YiSOMNaz3cJhGfQO5g8g8DYdcU-C5keOKkAmPF0tlltwxWF-CWkzWuo9AIn8fVLkkacL916z5rgszIh7xkEOybqLDT7n0QH-pDmctEWhNd_XiHTeWaO_TOb5RYJvVnlBQXtXbgIVvTRGeT9lwOnWgo0fCILIoewUTeMAd2J8t08mcpUxEb7CiI70vkM0tlsRMWstr--D8tZw4t9G7dzshYpkt3jRcGEGp5NG8dpRQRDkN3_HLrTcR5EuN4ikRBzw-YQKiPtLPnMsuNDkGmarZDyX_apmlHHxGgPH3TcbvFrs06Zaix9vH5JefXvKSpUMo-_8dkShlUSYOSVExd9Kg6K2HXrk2-3jbCFm6HrEjL8DFD5QG1w3UuhuZvlBtkCqsDvxMS8L96CdS4qOGMZxg58wdxTxj9a6b7MCP044G-ZsHfYlbZ00Cnb5Ob2ee1hXgZxuWD73IEKXMkaGe-I8nQ2WT4XLQ-gEeXrcDk77G3XaMtFvqfMSJrAUWdHXGlx1NhnzrUgdQB4aM037KAUpJUi0l12HxD6d29EtzI9Nc0lqHhrlYEia0D8jGHkTdu2BTfBXS-z8BSml06OoXtaNQNDc8ITU3xsevz0-g80ZfJupFlILCkQC4GZx7cN_6lkIbsrESkuP3QRcWdHSsab8D9ANcIT2WYMvubcubgw1vr_SljwMcjjXkHftMEqEC4EQ548BiT4v8mHcZcA6HOCyxkJDD86jn1KZVrucVmsi6nxROR4Jg04jY_vOAPcNkfsdwwETr7sVjXHBmAZsx31HUv4xbCAOUGRP2CiXkDyyx-SRp01mF-vrReijXrUIPdSxBcY1XlMbpAlnlBA48ZLrDL5gkBkYIV48zLvpkYuo3rHKpQhldOeOocbSGxSOw7dmXs2XiGhlS9TgUy3Urizvc_LHymL5r5G525mP-zM_CrnrejZH7aP3fYDXgsB9fZLHcSXbkRZuRsUkJQkmL0-UL35KiBa-IyYhWcRx86OKi9idTW4H02CeY9fuzlf1UCZs0IoSQgQUdwoKggqHooHtle3VlaZ2RB5qE6sOytK_ERlbeImxIzAVeld4_E_KPpvWgZPY-2kN4cr8nUAxb0U8HYdM9-FA2Z_vA0yyhOcbLsYSr0jrtYW3YKAHx-MtEcOGs0RHHljZTgZYxMLLoKRBDbAD73TTkG4wAv0xt0g.b4y4uqYjAGhOpGYQGmaX9g'
  end

  def doorkeeper_token
    application = FactoryBot.create(:application)
    token = FactoryBot.create(:doorkeeper_access_token, application: application)
    token.token
  end
end
