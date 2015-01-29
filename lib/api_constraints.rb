class ApiConstraints
	def initialize(options)
		@version = options[:version]
		@default = options[:default]
	end

	def matches?(request_param)
		@default || request_param.headers['Accept'].include?("application/vnd.marketplace.dev/v#{@version}")
	end
end