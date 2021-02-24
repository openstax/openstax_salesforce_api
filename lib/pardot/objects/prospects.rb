require 'cgi'

module Pardot
  module Objects
    module Prospects

      def prospects
        @prospects ||= Prospects.new self
      end

      class Prospects

        def initialize(client)
          @client = client
        end

        def query(search_criteria)
          result = get '/do/query', search_criteria, 'result'
          result['total_results'] = result['total_results'].to_i if result['total_results']
          result
        end

        def read_by_email(email, params = {})
          post "/do/read/email/#{CGI.escape(email)}", params
        end

        def read_by_id(id, params = {})
          post "/do/read/id/#{CGI.escape(id)}", params
        end

        def read_by_fid(fid, params = {})
          post "/do/read/fid/#{CGI.escape(fid)}", params
        end

        protected

        def get(path, params = {}, result = 'prospect')
          response = @client.get 'prospect', path, params
          result ? response[result] : response
        end

        def post(path, params = {}, result = 'prospect')
          response = @client.post 'prospect', path, params
          result ? response[result] : response
        end

      end

    end
  end
end
