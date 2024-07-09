require 'uri'
require 'net/http'
require 'json'
require 'dotenv/load'


class APIEasyBroker
    def initialize(api_url, token)
        @url = URI(api_url)
        @token = token
    end

    def fetch_properties
        http = Net::HTTP.new(@url.host, @url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(@url)
        request["accept"] = 'application/json'
        request["X-Authorization"] = @token

        response = http.request(request)
        response_body = JSON.parse(response.read_body)
        response_body
    end
    
    def print_titles
        response_body = fetch_properties

        content_array = response_body["content"]

        if content_array
            content_array.each do |property|
                puts "Title: #{property['title']}"
            end
        else
            puts "Array 'content' not found in JSON reponse"
        end
    end
end

api_url = URI("https://api.stagingeb.com/v1/properties")
api_token = 'l7u502p8v46ba3ppgvj5y2aad50lb9'
api_client = APIEasyBroker.new(api_url, api_token)
api_client.print_titles