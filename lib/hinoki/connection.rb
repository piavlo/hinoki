# hinoki/connection.rb

require 'json'
require 'net/http'
require 'hinoki/config'

class Hinoki
  class Connection

    def initialize
      @config = Hinoki::Config.new
      @http = Net::HTTP.new(@config.host, @config.port)
    end

    # Wrapper around Net::HTTP.get
    def get(path)
      return interpret_response(@http.get(path))
    end

    # Wrapper around Net::HTTP.post
    def post(path)
      return interpret_response(@http.post(path))
    end
    
    # Wrapper around Net::HTTP.delete
    def delete(path)
      return interpret_response(@http.delete(path))
    end
   
    private

    # Helper to basically handle any repsonse we could get.
    def interpret_response(response)
      case response.code.to_i
      when 200
        puts 'OK'
      when 201
        puts 'Success'
      when 204
        puts 'Success; no content'
        return
      when 400
        puts 'Invalid request'
        return
      when 404
        puts 'Resource not found'
        return
      when 500
        puts 'Sensu encountered an error'
        return
      else
        puts 'Unknown HTTP response code ...'
        return
      end

      return JSON.parse(response.body)
    end
  end
end
