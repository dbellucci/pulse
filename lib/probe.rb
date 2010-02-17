class NetworkProbe
	def each(&block)
		@callback = block
	end

	def self.probe(host, opts={})
		self.new(host, opts) do |core|
			yield core if block_given? 

			probe = core.build_probe
			core.run(probe, host)
		end
	end

	def run(probe, host)
		loop do
			@count.times do 
				if probe.ping? host then
					report(probe.duration)
				else
					puts "#{target} is dead!"
					report(0)
				end				

				Kernel.select nil, nil, nil, @round_trip
			end
			
			Kernel.select nil, nil, nil, @frequency
		end	
	end
	
	def report(time)
		if @previous.nil? or (time - @previous).abs >= @delta then
			@callback.call(time) if not @callback.nil?
			
			@previous = time
		end
	end

	def initialize(host, opts={})
		@previous = nil
		@callback = nil

		@delta      = opts[:delta] ||= 0
		@count      = opts[:count] ||= 5
		@frequency  = opts[:frequency]  ||= 10
		@round_trip = opts[:round_trip] ||= 0.05
		

		yield self if block_given? 
	end	
end

