# Description:
#   Basic interface for FOAAS.com
#
# Commands
#   fu <object> - tells <object> to f off with random response from FOAAS
#   fu <the_fu> <object> - tells <object> to f off with <the_fu> from FOAAS
#
# Dependencies:
#   None

options = [
  'off',
  'you',
  'donut',
  'shakespeare',
  'linus',
  'outside',
  'madison',
  'yoda'
]

module.exports = (robot) ->
  robot.hear /^fu (\w+)( (.+))?/i, (msg) ->
    from  = msg.message.user.name
    to = the_fu = ""
    if msg.match[1].toLowerCase() in options
      the_fu = msg.match[1]
      to = msg.match[3]
    else
      the_fu = msg.random options
      to = msg.match[1]
      if msg.match[2]?
        to += msg.match[2]

    msg.http("http://foaas.com/#{the_fu}/#{to}/#{from}/")
      .headers(Accept: 'application/json')
      .get() (err, res, body) ->
        try
          json = JSON.parse body
          msg.send json.message
          msg.send json.subtitle
        catch error
          msg.send "Fuck this error!"