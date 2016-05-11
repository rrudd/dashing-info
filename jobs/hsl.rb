require 'net/https'
require 'json'

host = "api.reittiopas.fi"
stops = ["1130139", "1130439", "1130109", "1130438", "1130110"]
user = ENV['HSL_USER']
pass = ENV['HSL_PASS']

puts("USER AND PASS")
puts(user)
puts(pass)

def line_from_code(code)
  line = code[1..4]
  line.gsub!(/^0+/,'')
  line = line.strip
  return line
end

def time_string_from_int(time_int)
  time_str = time_int.to_s.rjust(4, '0').insert(2, ":")
  return time_str
end

def destination_from_code(code, destinations)
  destination = destinations[destinations.index{|s| s.include?(code)}][8..-1]
  return destination
end

SCHEDULER.every '1m', :first_in => 0 do |job|
  all_departures = []
  time_limit = Time.now + 2*60
  time_limit_str = time_limit.strftime("%H:%M")
  stops.each do |stop|
    response = Net::HTTP.get_response(host,"/hsl/prod/?request=stop&user=#{user}&pass=#{pass}&format=json&code=#{stop}")
    stop = JSON.parse(response.body)
    destinations = stop[0]["lines"]
    departures = stop[0]["departures"]
    departures.each do |departure|
      departure["line"] = line_from_code(departure["code"])
      departure["time_str"] = time_string_from_int(departure["time"])
      departure["destination"] = destination_from_code(departure["code"], destinations)
      if departure["time_str"] > time_limit_str
        all_departures << departure
      end
    end
  end
  sorted_departures = all_departures.sort_by { |dep| dep["time"] }
  send_event('hsl', { departures: sorted_departures[0..18] })
end
