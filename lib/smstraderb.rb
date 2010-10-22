require 'net/https'
require 'smstraderb/constants'
require 'smstraderb/response'

class SMSTradeRB
  class InvalidRoute < Exception; end
  class InvalidOption < Exception; end
  class InvalidFormat < Exception; end

  attr_reader :key, :message, :to, :from, :route, :debug, :charset

  def initialize(options = {})
    @charset = 'UTF-8'

    @key = options[:key]
    @message = options[:message]
    @to = check_phone_number(options[:to])
    @route = check_route(options[:route]) || SMSTradeRB::DEFAULT_ROUTE
    @from = options[:from]
    @debug = options[:debug] ? 1 : 0

    check_from_allowed(@from, @route)
    check_value_length(@from, 11) if @from

    @message = escape(@message)
    @from = escape(@from)
  end

  def send(options)
    @to = escape(check_phone_number(options[:to]))
    @message = escape(options[:message])

    uri = URI.parse(SMSTradeRB::HTTP_GATEWAY)
    http = Net::HTTP.new(uri.host, uri.port)
    #http.use_ssl = true if uri.scheme == "https"  # enable SSL/TLS

    response = http.start do
      http.request_get(build_request)
    end

    SMSTradeRB::Response.new(response.body)
  end

  private
    def build_request
      options = {
        :key => key,
        :message => message,
        :to => to,
        :route => route,
        :from => from,
        :debug => debug,
        :charset => charset
      }.map do |key, value|
        [key, value].join('=') if value
      end.compact

      "/?#{options.join('&')}"
    end

    def check_phone_number(number)
      if number and number.to_s !~ %r{^\+?[\s0-9\-\(\)]+$}
        raise SMSTradeRB::InvalidFormat, "Invalid phone number: #{number}"
      else
        sanitize_phone_number(number)
      end
    end

    def check_from_allowed(from, route)
      if from and ![:gold, :direct].include?(route)
        raise SMSTradeRB::InvalidOption, "Setting the from option is only allowed with a :gold or :direct route."
      end
    end

    def check_route(route)
      return nil unless route

      if SMSTradeRB::ROUTES.include?(route.to_sym)
        route
      else
        raise SMSTradeRB::InvalidRoute, "Route #{route} does not exist."
      end
    end

    def check_value_length(value, limit)
      if (bytesize(value) > 11)
        raise SMSTradeRB::InvalidFormat, "Value '#{value}' too long. (limit: #{limit})"
      end
    end

    def sanitize_phone_number(number)
      return nil unless number
      number.gsub(%r{[\s\-\(\)]+}, '')
    end

    # The following two methods came from rack-1.1.0.
    def escape(s)
      return nil unless s
      s.to_s.gsub(/([^ a-zA-Z0-9_.-]+)/n) {
        '%' + $1.unpack('H2'*bytesize($1)).join('%').upcase
      }.tr(' ', '+')
    end

    def bytesize(s)
      s.respond_to?(:bytesize) ? s.bytesize : s.size
    end
end
