require 'lib/icmp'
require 'lib/http'
require 'lib/db'

include DB

DB::open('HTTP_pulse.sqlite')

HTTP.probe('http://www.google.it/', :round_trip => 0.05, :frequency => 3, :delta => 0.0005) do |probe|
	probe.each do |rtt|
		DB::report(rtt.to_s)
				
		puts "#{Time.now.to_s} rtt:  #{rtt.to_s}"
	end
end
