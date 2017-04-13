# Biju

Biju is an easy way to mount a GSM modem to send, to receive and to delete messages through a ruby interface.
This is project is based on this [code snippet](http://dzone.com/snippets/send-and-receive-sms-text).

## Installation

Add this line to your application's Gemfile:

    gem 'biju'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install biju

## Usage

```
modem = Biju::Hayes.new('/dev/tty.HUAWEIMobile-Modem', pin: '0000')

# method to list all messages
# it can take the status in argument
# :unread, :read, :unsent, :sent, :all
modem.messages.each do |sms|
  puts sms
end

# method to send sms
sms = Biju::Sms.new(phone_number: '+3312345678', message: 'hello world')
modem.send(sms)

modem.close
```

## TODO

1. Write missing test for modem module.
2. Write a documentation.
3. Test with different kinds of modem and OS.
4. Handle UDH (User Data Header) and SMS longer than 140 octets

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Resources

http://en.wikipedia.org/wiki/GSM_03.40
http://www.etsi.org/deliver/etsi_gts/04/0408/05.00.00_60/gsmts_0408v050000p.pdf
http://www.etsi.org/deliver/etsi_ts/101000_101099/101032/05.01.00_60/ts_101032v050100p.pdf
http://en.wikipedia.org/wiki/Short_message_service_center
http://en.wikipedia.org/wiki/AT_command
http://subnets.ru/saved/sms_pdu_format.html
http://jazi.staff.ugm.ac.id/Mobile%20and%20Wireless%20Documents/SMS_PDU-mode.PDF
http://www.sendsms.cn/download/SMS_PDU-mode.PDF
http://www.sendsms.cn/download/wavecom/PDU%B6%CC%D0%C5%CF%A2/SMS_PDU-mode.PDF
http://www.gsm-modem.de/sms-pdu-mode.html
http://www.developershome.com/sms/cmgrCommand3.asp
http://www.developershome.com/sms/cmgsCommand4.asp
http://en.wikipedia.org/wiki/Concatenated_SMS

# Encoding
http://en.wikipedia.org/wiki/GSM_03.38
http://www.3gpp.org/ftp/Specs/html-info/0338.htm
http://www.codeproject.com/Tips/470755/Encoding-Decoding-7-bit-User-Data-for-SMS-PDU-PDU
https://github.com/bitcoder/ruby_ucp/wiki/SMS-Alphabets

# AT Commands
http://en.wikipedia.org/wiki/Hayes_command_set
https://www.sparkfun.com/datasheets/Cellular%20Modules/ADH8066-AT-Commands-v1.6.pdf
http://www.coster.eu/costerit/teleges/doc/gsm822w.pdf
http://www.developershome.com/sms/cmglCommand.asp
http://www.zoomtel.com/documentation/dial_up/100498D.pdf

AT+CLAC > list supported commands
