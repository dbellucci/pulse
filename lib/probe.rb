class NetworkProbe
	attr_accessor :count, :delta, :frequency, :round_trip, :timeout

	def on_fail(&block)
		@errback = block
	end
	
	def on_pulse(&block)
		@callback = block
	end

	def self.probe(host, opts={})
		self.new(host, opts) do |core|
			yield core if block_given? 

			core.run(host)
		end
	end

	def run(host)
		loop do
			@count.times do |i|
				if ping host then
					report(host)
				else
					if not @errback.nil? then
						@errback.call(host)
					end
				end				

				if i.next < @count 
					Kernel.select nil, nil, nil, @round_trip
				end
			end
			
			Kernel.select nil, nil, nil, @frequency
		end	
	end
	
	def report(host)
		if @previous.nil? or (@duration - @previous).abs >= @delta then
			@callback.call(host, @duration) if not @callback.nil?
			
			@previous = @duration
		end
	end

	def initialize(host, opts={})
		@previous = nil
		@callback = nil
		@errback  = nil
		
		@delta      = opts[:delta] ||= 0
		@count      = opts[:count] ||= 5
		
		@frequency  = opts[:frequency]  ||= 5
		@round_trip = opts[:round_trip] ||= 1
		@timeout    = opts[:timeout]    ||= 5

		yield self if block_given? 
	end	
end

