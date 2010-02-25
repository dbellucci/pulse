require 'pulse'

include Pulse

Pulse::DB::open('ICMP_pulse.sqlite')

ICMP.pulse(:target => '192.168.1.1', :count =>5, :round_trip => 5) do |probe|	
	probe.on_fail do |echo|
		Pulse::STDERR.report echo
	end

	probe.on_pulse do |echo|
		[Pulse::STDOUT, Pulse::DB].each do |r|
			r.report echo
		end
	end
end

