#!/usr/bin/env ruby
#encoding: utf-8

$: << 'lib'

require 'biju'
require 'pp'

#str = 'www.ruby-lang.org and bonjour www.rubygarden.org coucou'
#re = /
#      (               # capture the hostname in $1
#        (?:           # these parens for grouping only
#          (?! [-_] )  # lookahead for neither underscore nor dash
#          [\w-] +     # hostname component
#          \.          # and the domain dot
#        ) +           # now repeat that whole thing a bunch of times
#        [A-Za-z]      # next must be a letter
#        [\w-] +       # now trailing domain part
#      )               # end of $1 capture
#     /x               # /x for nice formatting
#str = '((www.ruby-lang.org), (www.rubygarden.org), (www.co.com) ucou)'
strs = []
strs << '((www.ruby-lang.org), (www.rubygarden.org), (www.co.com) (u)cou)'
strs << '(www.ruby-lang.org), (www.rubygarden.org), (www.co.com) (u)'

re =  /
        \(             # parenthese
          (
            #[^\(\)]*?
            [\(\)]*?
            .*?
          )
        \)             # parenthese
      /x

strs.each do |str|
  pp "STR : #{str}"
  str.gsub! re do      # pass a block to execute replacement
    pp $1
  end
end

exit

puts "here"
hayes = Biju::HayesSms.new
pp hayes.attention
pp hayes.answer = 'OK'
pp hayes.ok?
pp hayes.init_modem
pp hayes.answer = 'OK'
pp hayes.ok?
pp hayes.text_mode
pp (hayes.answer = 'OK')
pp hayes.ok?
pp hayes.prefered_storage?
pp hayes.answer = '+CPMS: ("ME","MT","SM","SR"),("ME","MT","SM","SR"),("ME","MT","SM","SR")'
# ((),(),())
# (),(),()
# 1,2

pp hayes.ok?

exit

@modem = Biju::Modem.new(:port => "/dev/ttyUSB0", :pin => '2382')

# method to list all messages
@modem.messages.each do |sms|
  puts sms
end

# method to send sms
sms = Biju::Sms.new(:phone_number => "0668486469", :message => 'hello world3')
puts @modem.send(sms)

@modem.close


