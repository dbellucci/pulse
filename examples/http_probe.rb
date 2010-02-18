require 'lib/http'
require 'lib/pulsedb'

include PulseDB

PulseDB::db_open('HTTP_pulse.sqlite')

HTTP.probe('http://www.google.it/', :count =>5, :round_trip => 5, :frequency => 10, :delta => 0.005) do |probe|
	probe.each do |rtt|
		PulseDB::db_report(rtt)
				
		puts "#{Time.now.to_s} rtt:  #{rtt.to_s}"
	end
end
