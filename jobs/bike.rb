require 'net/https'
require 'json'

url = "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql"

# url = "http://jsonplaceholder.typicode.com/posts"

SCHEDULER.every '1m', :first_in => 0 do |job|
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  body = '{ bikeRentalStation(id: "A38") {bikesAvailable spacesAvailable } }'
  request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/graphql'})
  request.body = body

  # puts("REQUEST INSPECT")
  # puts(request.inspect)
  # response = Net::HTTP.get_response(uri)
  response = http.request(request)
  # puts("RESPONSE INSPECT")
  # puts(response.inspect)
  # puts(response.body)
  json_content = JSON.parse(response.body)
  bikes_available = json_content["data"]["bikeRentalStation"]["bikesAvailable"]
  spaces_available = json_content["data"]["bikeRentalStation"]["spacesAvailable"]
  # puts("JSON")
  # puts(bikes_available)

  send_event('bike', { bikes: bikes_available, spaces: spaces_available })
end
