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

  config.before do
    allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
  end

  def oxa_cookie
    'oxa_dev=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..CKFrfI-3wsGNAc1i.ilsVuaZ-xJgziluj7AyiuicOM5bdjWxuxwmgDE_-HOsEteQ3ypdZa16QYbDHTzZxDyu89zaFoZHWeHlE6qimeF5-XhuI_Vf12yyD2R5dBwd7xFZfkO1qmPUFiPnjU1SLCxbET6a516x3F4-TEKssUE6FW_1Kkayr6rW7wkpBv1rYQRDVpnNANLVPx5Jj9zSMiT6G1o10umc7nNz1OBbZ-7WHmoRPMjhWSQ7uwJgdZweD542ckOEboov8dH1rZfe5cXXr5m_qAxh3vk9-8GtsZOnAQNJrzB3P8gclnZvT_1myghZO7SfNNJfz36Wqi1Mu44SvQFf3DDFAXfDiXiaE1KZHCWZBQpliIIxxC9opGpXNhwYFL6Q8eYEvH2Tsfjfisp9iS46vceymj-cas5f4HsfWpKemi72cTsFlxgJa3eX9zOeYrtCG7tn5jf4YkkcDNzA6D4UvbfuKX-RH9gp3Yq1VV-qdnBlWUasshln1Gd0MW7JkpLZUBAe6INj-BneRvQOKEiRFii61Fts1Gjv7hxP-zmHK5HxIqTgO_8f0M0Zq-n80QLoXIP4qXfsBvztGSQV9iJea09dYjrsY_txhStxnMQtiL-qPgQkiOO4E6a-hRRbBdJL9bBEY2VqQLBGMdRIMsToix2_sgSZ_fHMP-tyWc_fsjdSewXkYRBCjDsv5zsZczS3Snck8HBcX1iPYnKhoSO6864psPHvl8KVglcmIrdKiHUcvSCniQ80qyBehB9t1eGJQSqK8HHkN7Fz6HWfblvTkEAkgshNbCbBkqSVw9QecN7_OjNcnSoBCAYAdQTr_jvcKfNP8qi5Q2N2tuolwo4ESx0v3TO3Iw0Ou64C_OQxhtSAOPoTSrgxFMygHFkuZiIlwFxzJlQa7mUnRcy-UHusoFEo0_6kFHUx-1XNOR1fX_C51-IxITKv8sLS2l_EXY2Gf8IR4mWIC8S2QmSQkod-Rh8cI9_72GuudC13Lre-eeOnPDxqoJubfEdMlBZI_g-jMTm3ss3SPcUMRuAjYg0stQeunQvwawwcbQEi2sUzs5SxV7HveyFe7eqpoKVxNSIF9b9Phoc6Y3kj-fgaNpXliiTYRBvVIwAh1Tvvc__UzdfbEYE3trW0R0pYaA__PwOSKCclvXG3R3ogg1XVz7pHgCP0Hc2u0TivfQKLKWuPa9F3WGAZtc3GOsDpeALyTNzqAAV5UAV1RZ1DlrpC9hkgaP5_4JFv6a-2y36Sp2aOILNdM6opySyEMKpLgLMDepiOHU2jsuyVd3nTrVCI12LHrtVJd_9JTgsosWcks7oS40Vw7gl2UfsgZonY4FBCZiS5hoi23_MGbL97pKlJoi16OonvGZLe01vujLCG48hyKRhwS_C8WVcSDpCXl8xsPA1qInD4Ed-Qc-arCADwPfA.Uk13fkTgBuiEw8Spa5zBEw'
  end

  def invalid_user_cookie
    'oxa_dev=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..QdX5SwjkpcP0cOaa.SNf1yadprqqloyxKOocEsWaZ3VjWNSUPnHMShKH-ulyr4d5Zj2ReupUBfzRgz-5pwEWZ5iN_LcO-Vc9-NSRBp_QPHpiIMls60nOYTokK5qostdjmUbQGyjV5F3MIfMmZwfbPgY5XJT5T-3MDQ3b4nF8ulBbufsphwsNsl6UFkEp5PjN1FTJ6P9fXkkvQNgmiUuP8QITdbkN6RNvbx3MkNS36Ly44c_HLIEqEZ5QF8M2buovgh_xvNuo56EEywpnKkJfKHQ23eg2ycVtvpeyUhsUpMSyur_L9olcGFyzJIYp6Q_xunXnZDz6hMvt5baOFwaLNyfv20IbqMKeQ-srz9dL9AgY--LwrhW3yvyTZefKApOUigqZ6V4pgicKSqDRpl3LEUYm_yHTSFeUFJoXlXDYa-WbMaK3BvK8qLWQhEo3UtGVlDDtZzva3rCVbSTmc2aav_3c0CsanygiKgctvbC3y3mgUTqQSOj0j06iHsAwi1rQcurqX5uZUN2g-FLHMNU3RQrH7NlxGSX8PrDYhS49q8ER5DvQdoSjIckVSrmaYGLmQxAI4ZRRf0uzULXJLwti4Cz6odbEqKMU5hvg8i8LqoX4reKYHmzNCePQO1W6wltaII7_67kARnS_OQ8_dQQeTkSQiqRxbKyic4M33XMmpkSRdyPQLPlffwtDl4qus5RSgc1RpJHRAJF81GB5nGgP98zr9j8gUIkAPpLoxLR85RLehDUxByVJAmF35p4r6CZ1ABRH3vXH0UBrpLL0OltNJc66E7amzHLhj3JvebF4yIjCVdF4P8qe5f8wopVONjnCmHwRboqs2AknBYpdVGMb0SbyYugthx3NgfCblrjMGtLN00z_N4UUP_ktW16dzrV_PMxrsBpeI1J2PwLG_HxxmT8J8fZocwmS0PQShxqcwjmMwHAyq60VBkbXdBSvTMkTnrv1MiFIb2ad-ASKtURL5ZwxeGl06u8sUW3QowEkLYJdMnggoc4dWi9ak36TOpDsSL34nLErCTFk96xStUNDxmRUWHQ14VNDdhvMcc3ryVYoV5wpiK3Xpwu6-5-H_4AhuWmOiHDTW6e5I7iohdA5TvRZ5VZPSiqSH30AHIXLfk3VPU7wG30MiVW-eYaQFH9wYGT3hJLpBUwoOAkj_ZRrxSTLQsE8b09SZAwkuArPj4XcWHtEDOekhqzy1z9v8aIN5ysrIHJvQubKjguKYi_rky4OrL-vEkiF6K4ayaCcQQaD0B09ajinUbFZDiIbqc8kM0FAVs98_Okb8xcgA_IGaibM02dxgy-sMoQ.QtbCTF_nrjVm_SQpHsB02w'
  end

  def doorkeeper_token
    application = FactoryBot.create(:application)
    token = FactoryBot.create(:doorkeeper_access_token, application: application)
    token.token
  end
end
