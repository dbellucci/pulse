class NetworkProbe
	def each(&block)
		@callback = block
	end

	def self.probe(host, opts={})
		self.new(host, opts) do |core|
			yield core if block_given? 

			core.run(host, opts)
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

		@delta = opts[:delta] ||= 0

		yield self if block_given? 
	end	
end

