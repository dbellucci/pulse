require 'pulse'


include Pulse

Pulse::DB::open('DNSA_pulse.sqlite')

DNS.pulse(:target => '8.8.8.8', :host => 'www.google.it', :count =>5, :round_trip => 1) do |probe|
	probe.grep "74.125.39.991"

	probe.on_fail do |echo|
		Pulse::STDERR.report echo
	end

	probe.on_pulse do |echo|
		[Pulse::STDOUT, Pulse::DB].each do |r|
			r.report echo
		end
	end
end
