require 'net/https'
require 'json'

host = "api.reittiopas.fi"
stops = ["1130139", "1130439", "1130109", "1130438", "1130110"]
user = "netlight-info"
pass = "Mensch2016"

def line_from_code(code)
  line = code[1..4]
  line.gsub!(/^0+/,'')
  line = line.strip
  return line
end

SCHEDULER.every '1m', :first_in => 0 do |job|
  all_departures = []
  stops.each do |stop|
    response = Net::HTTP.get_response(host,"/hsl/prod/?request=stop&user=#{user}&pass=#{pass}&format=json&code=#{stop}")
    stop = JSON.parse(response.body)
    stop_departures = stop[0]["departures"]
    stop_departures.each do |departure|
      departure["line"] = line_from_code(departure["code"])
      departure["time_str"] = departure["time"].to_s.insert(2, ":")
      all_departures << departure
    end
  end
  sorted_departures = all_departures.sort_by { |dep| dep["time"] }
  puts sorted_departures
  send_event('hsl', { departures: sorted_departures[0..20] })
end
