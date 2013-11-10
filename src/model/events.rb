module Events	

	def add_listener listener, event, handler=nil
		add_event event
		handler = event unless handler
		@listeners[event] << {listener: listener, handler:handler}
	end

	def add_event event
		@listeners ||= {}
		@listeners[event]||=[]
	end

	def notify event, params=nil
		if @listeners and @listeners[event]
			@listeners[event].each{ |e| e[:listener].send(e[:handler], params) }
		end
	end
end