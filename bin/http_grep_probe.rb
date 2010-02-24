require 'pulse'


include Pulse

Pulse::DB::open('HTTP_pulse.sqlite')

HTTP.pulse(:target => 'http://localhost/', :count =>5, :round_trip => 5) do |probe|
	probe.grep 'works'

	probe.on_fail do |echo|
		Pulse::STDERR.report "#{echo} not alive"
	end

	probe.on_pulse do |echo|
		[Pulse::STDOUT, Pulse::DB].each do |r|
			r.report echo
		end
	end
end
