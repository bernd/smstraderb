require 'smstraderb/constants'

class SMSTradeRB
  class InvalidResponse < Exception; end
  class UnknownResponse < Exception; end

  class Response
    def initialize(response)
      check_response_string(response)
      @code, @message_id, @cost, @count = response.split("\n")
      check_response_code
    end

    def code
      @code.to_i
    end

    def message_id
      blank?(@message_id) ? nil : @message_id
    end

    def cost
      blank?(@cost) ? nil : @cost.to_f
    end

    def count
      blank?(@count) ? nil : @count.to_i
    end

    def ok?
      code == 100
    end

    def error?
      !ok?
    end

    def response_message
      SMSTradeRB::RESPONSE_CODES[code]
    end

    private
      def check_response_string(value)
        if value.nil?
          raise SMSTradeRB::InvalidResponse, 'Response string is nil.'
        end
        if value.empty?
          raise SMSTradeRB::InvalidResponse, 'Response string is empty.'
        end
        if value !~ %r{^\d+}
          raise SMSTradeRB::InvalidResponse, "Invalid response string: #{value}."
        end
      end

      def check_response_code
        unless SMSTradeRB::RESPONSE_CODES.key?(code)
          raise SMSTradeRB::UnknownResponse
        end
      end

      def blank?(value)
        value.nil? || value.empty? ? true : false
      end
  end
end
