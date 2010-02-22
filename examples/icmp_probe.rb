require 'lib/icmp'
require 'lib/pulsedb'

include PulseDB

PulseDB::db_open('ICMP_pulse.sqlite')

ICMP.probe('10.20.36.1') do |probe|	
	probe.on_fail do
		puts "host is not alive"
	end

	probe.on_pulse do |host, rtt|
		PulseDB::db_report(rtt)
				
		puts "#{Time.now} rtt:  #{rtt}"
	end
end
