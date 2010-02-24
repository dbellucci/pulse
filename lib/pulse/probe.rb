module Pulse
	class NetworkProbe
		attr_accessor :count, :delta, :round_trip, :timeout

		def on_fail(&block)
			@errback = block
		end
	
		def on_pulse(&block)
			@callback = block
		end

		def self.pulse(opts={}, target=nil)
			self.new(opts) do |core|
				yield core if block_given? 

				core.run((target.nil?)? opts[:target]: target)
			end
		end

		def run(host)
			id = 0
			
			until id.eql? count  do
				if ping host then
					if @previous.nil? or (@duration - @previous).abs >= @delta then
						@previous = @duration
						
						unless @callback.nil?
							@callback.call(:host => host, :id=> id, :rtt => @duration) 
						end
					end
				else
					if not @errback.nil? then
						@errback.call(:host => host, :id => id)
					end
				end				
				
				id = id.next
				Kernel.select nil, nil, nil, @round_trip
			end	
		end

		def initialize(opts={})
			@previous = nil
			@callback = nil
			@errback  = nil
		
			@delta      = opts[:delta] ||= 0
			@count      = opts[:count] ||= nil
		
			@round_trip = opts[:round_trip] ||= 1
			@timeout    = opts[:timeout]    ||= 5

			yield self if block_given? 
		end	
	end
end

