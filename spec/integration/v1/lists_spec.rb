require 'rails_helper'
require 'swagger_helper'
require 'vcr_helper'

RSpec.describe 'api/v1/lists', type: :request, vcr: VCR_OPTS do
  before(:all) do
    @list = FactoryBot.create :list
    @contact = create_contact(salesforce_id: '0030v00000UlS9yAAF')

    VCR.use_cassette('Pardot/lists.yml', VCR_OPTS) do
      OpenstaxSalesforceApi::Application.load_tasks
      Rake::Task['pardot:update_lists'].invoke
    end
  end

  path '/api/v1/lists' do
    get 'Retrieve all public mailing lists' do
      tags 'Lists'
      consumes 'application/json'
      parameter name: :list, in: :body, schema: {
        type: :object,
        properties: {
          pardot_id: { type: :string },
          title: { type: :string },
          description: { type: :string },
          created_at: { type: :string },
          updated_at: { type: :string }
        }
      }
      response '200', 'lists retrieved' do
        let(:list) { @list }
        run_test! do |response|
          expect(JSON.parse(response.body)).to include(hash_including('pardot_id'))
          expect(JSON.parse(response.body)).to include(hash_including('title'))
          expect(JSON.parse(response.body)).to include(hash_including('description'))
        end
      end
    end
  end

  path '/api/v1/lists/{list_id}/subscribe' do
    parameter name: :list_id, in: :path, type: :string

    get 'Subscribes to a mailing list' do
      tags 'Lists'
      consumes 'application/json'
      security [apiToken: []]

      response '202', 'subscribe successful' do
        let(:list_id) { @list.pardot_id }
        let(:HTTP_COOKIE) { 'oxa_dev=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..CKFrfI-3wsGNAc1i.ilsVuaZ-xJgziluj7AyiuicOM5bdjWxuxwmgDE_-HOsEteQ3ypdZa16QYbDHTzZxDyu89zaFoZHWeHlE6qimeF5-XhuI_Vf12yyD2R5dBwd7xFZfkO1qmPUFiPnjU1SLCxbET6a516x3F4-TEKssUE6FW_1Kkayr6rW7wkpBv1rYQRDVpnNANLVPx5Jj9zSMiT6G1o10umc7nNz1OBbZ-7WHmoRPMjhWSQ7uwJgdZweD542ckOEboov8dH1rZfe5cXXr5m_qAxh3vk9-8GtsZOnAQNJrzB3P8gclnZvT_1myghZO7SfNNJfz36Wqi1Mu44SvQFf3DDFAXfDiXiaE1KZHCWZBQpliIIxxC9opGpXNhwYFL6Q8eYEvH2Tsfjfisp9iS46vceymj-cas5f4HsfWpKemi72cTsFlxgJa3eX9zOeYrtCG7tn5jf4YkkcDNzA6D4UvbfuKX-RH9gp3Yq1VV-qdnBlWUasshln1Gd0MW7JkpLZUBAe6INj-BneRvQOKEiRFii61Fts1Gjv7hxP-zmHK5HxIqTgO_8f0M0Zq-n80QLoXIP4qXfsBvztGSQV9iJea09dYjrsY_txhStxnMQtiL-qPgQkiOO4E6a-hRRbBdJL9bBEY2VqQLBGMdRIMsToix2_sgSZ_fHMP-tyWc_fsjdSewXkYRBCjDsv5zsZczS3Snck8HBcX1iPYnKhoSO6864psPHvl8KVglcmIrdKiHUcvSCniQ80qyBehB9t1eGJQSqK8HHkN7Fz6HWfblvTkEAkgshNbCbBkqSVw9QecN7_OjNcnSoBCAYAdQTr_jvcKfNP8qi5Q2N2tuolwo4ESx0v3TO3Iw0Ou64C_OQxhtSAOPoTSrgxFMygHFkuZiIlwFxzJlQa7mUnRcy-UHusoFEo0_6kFHUx-1XNOR1fX_C51-IxITKv8sLS2l_EXY2Gf8IR4mWIC8S2QmSQkod-Rh8cI9_72GuudC13Lre-eeOnPDxqoJubfEdMlBZI_g-jMTm3ss3SPcUMRuAjYg0stQeunQvwawwcbQEi2sUzs5SxV7HveyFe7eqpoKVxNSIF9b9Phoc6Y3kj-fgaNpXliiTYRBvVIwAh1Tvvc__UzdfbEYE3trW0R0pYaA__PwOSKCclvXG3R3ogg1XVz7pHgCP0Hc2u0TivfQKLKWuPa9F3WGAZtc3GOsDpeALyTNzqAAV5UAV1RZ1DlrpC9hkgaP5_4JFv6a-2y36Sp2aOILNdM6opySyEMKpLgLMDepiOHU2jsuyVd3nTrVCI12LHrtVJd_9JTgsosWcks7oS40Vw7gl2UfsgZonY4FBCZiS5hoi23_MGbL97pKlJoi16OonvGZLe01vujLCG48hyKRhwS_C8WVcSDpCXl8xsPA1qInD4Ed-Qc-arCADwPfA.Uk13fkTgBuiEw8Spa5zBEw' }
        run_test!
      end
    end
  end

  path '/api/v1/lists/{list_id}/unsubscribe' do
    parameter name: :list_id, in: :path, type: :string

    get 'Unsubscribes from a mailing list' do
      tags 'Lists'
      consumes 'application/json'
      security [apiToken: []]

      response '202', 'unsubscribe successful' do
        Subscription.create(list: @list, contact: @contact)
        let(:list_id) { @list.pardot_id }
        let(:HTTP_COOKIE) { 'oxa_dev=eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..CKFrfI-3wsGNAc1i.ilsVuaZ-xJgziluj7AyiuicOM5bdjWxuxwmgDE_-HOsEteQ3ypdZa16QYbDHTzZxDyu89zaFoZHWeHlE6qimeF5-XhuI_Vf12yyD2R5dBwd7xFZfkO1qmPUFiPnjU1SLCxbET6a516x3F4-TEKssUE6FW_1Kkayr6rW7wkpBv1rYQRDVpnNANLVPx5Jj9zSMiT6G1o10umc7nNz1OBbZ-7WHmoRPMjhWSQ7uwJgdZweD542ckOEboov8dH1rZfe5cXXr5m_qAxh3vk9-8GtsZOnAQNJrzB3P8gclnZvT_1myghZO7SfNNJfz36Wqi1Mu44SvQFf3DDFAXfDiXiaE1KZHCWZBQpliIIxxC9opGpXNhwYFL6Q8eYEvH2Tsfjfisp9iS46vceymj-cas5f4HsfWpKemi72cTsFlxgJa3eX9zOeYrtCG7tn5jf4YkkcDNzA6D4UvbfuKX-RH9gp3Yq1VV-qdnBlWUasshln1Gd0MW7JkpLZUBAe6INj-BneRvQOKEiRFii61Fts1Gjv7hxP-zmHK5HxIqTgO_8f0M0Zq-n80QLoXIP4qXfsBvztGSQV9iJea09dYjrsY_txhStxnMQtiL-qPgQkiOO4E6a-hRRbBdJL9bBEY2VqQLBGMdRIMsToix2_sgSZ_fHMP-tyWc_fsjdSewXkYRBCjDsv5zsZczS3Snck8HBcX1iPYnKhoSO6864psPHvl8KVglcmIrdKiHUcvSCniQ80qyBehB9t1eGJQSqK8HHkN7Fz6HWfblvTkEAkgshNbCbBkqSVw9QecN7_OjNcnSoBCAYAdQTr_jvcKfNP8qi5Q2N2tuolwo4ESx0v3TO3Iw0Ou64C_OQxhtSAOPoTSrgxFMygHFkuZiIlwFxzJlQa7mUnRcy-UHusoFEo0_6kFHUx-1XNOR1fX_C51-IxITKv8sLS2l_EXY2Gf8IR4mWIC8S2QmSQkod-Rh8cI9_72GuudC13Lre-eeOnPDxqoJubfEdMlBZI_g-jMTm3ss3SPcUMRuAjYg0stQeunQvwawwcbQEi2sUzs5SxV7HveyFe7eqpoKVxNSIF9b9Phoc6Y3kj-fgaNpXliiTYRBvVIwAh1Tvvc__UzdfbEYE3trW0R0pYaA__PwOSKCclvXG3R3ogg1XVz7pHgCP0Hc2u0TivfQKLKWuPa9F3WGAZtc3GOsDpeALyTNzqAAV5UAV1RZ1DlrpC9hkgaP5_4JFv6a-2y36Sp2aOILNdM6opySyEMKpLgLMDepiOHU2jsuyVd3nTrVCI12LHrtVJd_9JTgsosWcks7oS40Vw7gl2UfsgZonY4FBCZiS5hoi23_MGbL97pKlJoi16OonvGZLe01vujLCG48hyKRhwS_C8WVcSDpCXl8xsPA1qInD4Ed-Qc-arCADwPfA.Uk13fkTgBuiEw8Spa5zBEw' }
        run_test!
      end
    end
  end
end
