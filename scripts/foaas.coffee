# Description:
#   Basic interface for FOAAS.com
#
# Commands
#   fu <object> - tells <object> to f off with random response from FOAAS
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
	to
	[the_fu, to] = if msg.match[1].toLowerCase() in options
	  [msg.match[1], msg.match[3]]
	else
      [msg.random options, msg.match[1] + msg.match[2]]
    
    msg.http("http://foaas.com/#{the_fu}/#{to}/#{from}/")
      .headers(Accept: 'application/json')
      .get() (err, res, body) ->
        try
          json = JSON.parse body
          msg.send json.message
          msg.send json.subtitle
        catch error
          msg.send "Fuck this error!"