require 'lib/http'
require 'lib/pulsedb'

include PulseDB

PulseDB::db_open('HTTP_pulse.sqlite')

HTTP.probe('http://www.google.it/', :round_trip => 0.05, :frequency => 3, :delta => 0.0005) do |probe|
	probe.each do |rtt|
		PulseDB::db_report(rtt.to_s)
				
		puts "#{Time.now.to_s} rtt:  #{rtt.to_s}"
	end
end
