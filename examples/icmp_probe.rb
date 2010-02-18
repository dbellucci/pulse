require 'lib/icmp'
require 'lib/pulsedb'

include PulseDB

PulseDB::db_open('ICMP_pulse.sqlite')

ICMP.probe('192.168.20.1', :count =>5, :round_trip => 5, :frequency => 10, :delta => 0.005) do |probe|
	probe.each do |rtt|
		PulseDB::db_report(rtt.to_s)
				
		puts "#{Time.now.to_s} rtt:  #{rtt.to_s}"
	end
end
