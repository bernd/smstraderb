class SMSTradeRB
  VERSION = '0.1.0'

  HTTP_GATEWAY = 'http://gateway.smstrade.de/'
  HTTPS_GATEWAY = 'https://gateway.smstrade.de/'

  ROUTES = [:basic, :economy, :gold, :direct]
  DEFAULT_ROUTE = :basic

  MESSAGE_TYPES = [:flash, :unicode, :binary, :voice]

  RESPONSE_CODES = {
     10 => 'Invalid recipient number',
     20 => 'Invalid sender number',
     30 => 'Invalid message format',
     31 => 'Invalid message type',
     40 => 'Invalid route',
     50 => 'Authentication failed',
     60 => 'Insufficient funds',
     70 => 'Network not covered by route',
     71 => 'Invalid feature for selected route',
     80 => 'Handover to SMS-C failed',
    100 => 'Message accepted and sent',
    999 => 'Internal test response'
  }.freeze
end
