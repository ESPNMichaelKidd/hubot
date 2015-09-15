# Description:
#   FFL Standings and Scores
#
# Commands
#   hubot ffl scores <league> <week> - get scoreboard for 'espna' or 'espnb', week optional
#   hubot ffl standings <league> - get standings for 'espna' or 'espnb'
#
# Dependencies:
#   None

seasonId = 2015
espna = 367286
espnb = 847717

ffl_api_url = 'http://games.espn.go.com/ffl/api/v2/'
options = ['scores','standings']

module.exports = (robot) ->
  robot.respond /ffl (\w+)? (\w+)?( (\d+))?/i, (msg) ->
    
    if msg.match[1].toLowerCase() in options
      type = msg.match[1]

    if msg.match[2] is 'espna'
      leagueId = espna
    else if msg.match[2] is 'espnb'
      leagueId = espnb
    
    if !leagueId
      msg.send 'Error: must specify league'
      
    else if type is 'scores'
      url = ffl_api_url + 'scoreboard?seasonId=' + seasonId + '&leagueId=' + leagueId
      if msg.match[4] > 0
        url = url + '&scoringPeriodId=' + msg.match[4]
        
      robot.http(url)
        .get() (err, res, body) ->
          json = JSON.parse body
          scoreboard = json.scoreboard
          
          message = ""
          for matchup in scoreboard.matchups
            do (matchup) ->
              if (not matchup.bye)
                team1 = matchup.teams[0]
                team1Name = team1.team.teamLocation + ' ' + team1.team.teamNickname
                team1Pts = team1.score
                team1Str = team1Name + ' ' + team1Pts
                
                team2 = matchup.teams[1]
                team2Name = team2.team.teamLocation + ' ' + team2.team.teamNickname
                team2Pts = team2.score
                team2Str = team2Name + ' ' + team2Pts
                
                if team2Pts > team1Pts
                  message += '> ' + team1Str + ' - *' + team2Str + '*' + '\n'
                else
                  message += '> *' + team1Str + '* - ' + team2Str + '\n'
          msg.send message
                
    else if type is 'standings'
      url = ffl_api_url + 'standings?seasonId=' + seasonId + '&leagueId=' + leagueId
      
      robot.http(url)
        .get() (err, res, body) ->
          json = JSON.parse body
          teams = json.teams
        
          sortedTeams = []
          
          for team in teams
            do (team) ->
              teamNum = team.overallStanding
              teamRec = team.record.overallWins + '-' + team.record.overallLosses + '-' + team.record.overallTies
              teamName = team.teamLocation + ' ' + team.teamNickname
              teamPts = team.record.pointsFor
            
              teamStr = teamNum + ' (' + teamRec + ') ' + teamName + ' - ' + teamPts
              if teamNum < 7
                teamStr = '*' + teamStr + '*'
            
              sortedTeams[teamNum - 1] = teamStr
          
          message = ""
          for teamStr in sortedTeams
            do (teamStr) ->
              message += '> ' + teamStr + '\n'
          msg.send message