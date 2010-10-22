smstraderb
==========

# Description

This gem provides a Ruby client library for the smstrade.de HTTP API.

# Installation

    # gem install smstraderb

# Usage

    require 'smstraderb'

    key = 'you-smstrade-api-key'

    sms = SMSTradeRB.new(:route => :basic, :key => key, :debug => true)
    res = sms.send(:to => '123 456789', :message => 'hello api')

    if res.ok?
      puts "success!"
    else
      puts "error:"
      puts res.response_message
    end

# Contribute

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version
  in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

# Copyright

Copyright (c) 2010 Bernd Ahlers. See LICENSE for details.
