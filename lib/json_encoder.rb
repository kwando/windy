module JSONEncoder
		protected
		def json(data, status: 200)
			[status, {'Content-Type' => 'application/json'}, [JSON.pretty_generate(data)]]
		end
end