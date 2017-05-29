require 'net/https'
require 'json'

url = "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql"

SCHEDULER.every '1m', :first_in => 0 do |job|
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  body = '{ bikeRentalStation(id: "033") {bikesAvailable spacesAvailable } }'
  request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/graphql'})
  request.body = body

  response = http.request(request)

  json_content = JSON.parse(response.body)
  if json_content["data"]["bikeRentalStation"].nil?
    bikes_available = 0
    spaces_available = 0
  else
    bikes_available = json_content["data"]["bikeRentalStation"]["bikesAvailable"]
    spaces_available = json_content["data"]["bikeRentalStation"]["spacesAvailable"]
  end
  total_spaces = bikes_available + spaces_available

  send_event('bike', { bikes: bikes_available, spaces: total_spaces })
end
