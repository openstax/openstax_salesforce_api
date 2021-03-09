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
        },
        doorkeeperToken: {
          description: 'Doorkeeper OAuth token for API Calls',
          type: :oauth2,
          name: 'Authorization',
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
    'oxa=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..QdX5SwjkpcP0cOaa.SNf1yadprqqloyxKOocEsWaZ3VjWNSUPnHMShKH-ulyr4d5Zj2ReupUBfzRgz-5pwEWZ5iN_LcO-Vc9-NSRBp_QPHpiIMls60nOYTokK5qostdjmUbQGyjV5F3MIfMmZwfbPgY5XJT5T-3MDQ3b4nF8ulBbufsphwsNsl6UFkEp5PjN1FTJ6P9fXkkvQNgmiUuP8QITdbkN6RNvbx3MkNS36Ly44c_HLIEqEZ5QF8M2buovgh_xvNuo56EEywpnKkJfKHQ23eg2ycVtvpeyUhsUpMSyur_L9olcGFyzJIYp6Q_xunXnZDz6hMvt5baOFwaLNyfv20IbqMKeQ-srz9dL9AgY--LwrhW3yvyTZefKApOUigqZ6V4pgicKSqDRpl3LEUYm_yHTSFeUFJoXlXDYa-WbMaK3BvK8qLWQhEo3UtGVlDDtZzva3rCVbSTmc2aav_3c0CsanygiKgctvbC3y3mgUTqQSOj0j06iHsAwi1rQcurqX5uZUN2g-FLHMNU3RQrH7NlxGSX8PrDYhS49q8ER5DvQdoSjIckVSrmaYGLmQxAI4ZRRf0uzULXJLwti4Cz6odbEqKMU5hvg8i8LqoX4reKYHmzNCePQO1W6wltaII7_67kARnS_OQ8_dQQeTkSQiqRxbKyic4M33XMmpkSRdyPQLPlffwtDl4qus5RSgc1RpJHRAJF81GB5nGgP98zr9j8gUIkAPpLoxLR85RLehDUxByVJAmF35p4r6CZ1ABRH3vXH0UBrpLL0OltNJc66E7amzHLhj3JvebF4yIjCVdF4P8qe5f8wopVONjnCmHwRboqs2AknBYpdVGMb0SbyYugthx3NgfCblrjMGtLN00z_N4UUP_ktW16dzrV_PMxrsBpeI1J2PwLG_HxxmT8J8fZocwmS0PQShxqcwjmMwHAyq60VBkbXdBSvTMkTnrv1MiFIb2ad-ASKtURL5ZwxeGl06u8sUW3QowEkLYJdMnggoc4dWi9ak36TOpDsSL34nLErCTFk96xStUNDxmRUWHQ14VNDdhvMcc3ryVYoV5wpiK3Xpwu6-5-H_4AhuWmOiHDTW6e5I7iohdA5TvRZ5VZPSiqSH30AHIXLfk3VPU7wG30MiVW-eYaQFH9wYGT3hJLpBUwoOAkj_ZRrxSTLQsE8b09SZAwkuArPj4XcWHtEDOekhqzy1z9v8aIN5ysrIHJvQubKjguKYi_rky4OrL-vEkiF6K4ayaCcQQaD0B09ajinUbFZDiIbqc8kM0FAVs98_Okb8xcgA_IGaibM02dxgy-sMoQ.QtbCTF_nrjVm_SQpHsB02w'
  end

  def doorkeeper_token
    application =  FactoryBot.create(:application)
    token = FactoryBot.create(:doorkeeper_access_token, application: application)
    puts '***Token: ' + token.token
    token.token
  end
end
