require 'smstraderb/constants'

# This class tries to emulate the smstrade.de HTTP API v2.2.
# It provides a valid Rack endpoint.

class SMSTradeRB
  class Server
    def initialize(options = {})
      @options = options
    end

    def [](key)
      @options[key]
    end

    def call(env)
      params = Rack::Request.new(env).params

      # The route param is mandatory.
      unless params['route']
        return respond_with('40')
      end

      # There are only a few valid route values.
      unless SMSTradeRB::ROUTES.include?(params['route'].to_sym)
        return respond_with('40')
      end

      # The to params is mandatory.
      unless params['to']
        return respond_with('10')
      end

      # The to params needs to be in a valid format.
      unless params['to'] =~ /^\+?\d+/
        return respond_with('10')
      end

      # The key param is mandatory.
      unless params['key']
        return respond_with('50')
      end

      # The message params is mandatory.
      unless params['message']
        return respond_with('30')
      end

      # Check if the messagetype is valid.
      if params['messagetype'] and !SMSTradeRB::MESSAGE_TYPES.include?(params['messagetype'].to_sym)
        return respond_with('31')
      end

      # Everything is fine so far. We return 100.
      ret = [@options[:code] || 100]

      # Some optional parameters which modify the return value.
      if params['message_id'] == '1'
        ret[1] = '123456789'
      end

      if params['cost'] == '1'
        ret[2] = '0.055'
      end

      if params['count'] == '1'
        ret[3] = '1'
      end

      respond_with(*ret)
    end

    private
      def respond_with(*values)
        [200, {'Content-Type' => 'text/plain'}, [values.join("\n")]]
      end
  end
end
