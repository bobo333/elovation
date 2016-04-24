# create games
require 'json'

years = ['85_86', '86_87', '95_96', '15_16']


  def create_result(game, res_obj, create_date)
    result = game.results.build

    next_rank = Team::FIRST_PLACE_RANK
    teams = (res_obj[:teams] || {}).values.each.with_object([]) do |team, acc|
      players = Array.wrap(team[:players]).delete_if(&:blank?)
      acc << { rank: next_rank, players: players }

      next_rank = next_rank + 1 if team[:relation] != "ties"
    end

    teams = teams.reverse.drop_while{ |team| team[:players].empty? }.reverse

    teams.each do |team|
      result.teams.build rank: team[:rank], player_ids: team[:players][0][:id]
    end

    if result.valid?
      Result.transaction do
        game.rater.update_ratings game, result.teams, create_date

        result.created_at = create_date
        result.save!
      end
    else
      puts result.errors.messages
    end
  end


years.each do |year|

    games_file = File.open("/elovation/nba_data/json/#{year}/games.json")
    # games_file = File.open("../nba_data/json/#{year}/games.json")

    games_data = games_file.read
    games_file.close

    games_json = JSON.parse(games_data)

    # get game
    year_string = year.sub('_', '-')
    game = Game.find_by_name("#{year_string} Season")

    # pass game and teams (winner first, loser 2nd) to ResultService function

    games_json.each do |game_json|
        winner_name = game_json['winning_team']
        loser_name = game_json['losing_team']
        date_string = game_json['date']

        create_date = Date.strptime(date_string)

        winner = Player.find_by_name(winner_name)
        loser = Player.find_by_name(loser_name)

        res_obj = {
                teams: {
                    
                }
        }

        res_obj[:teams][1] = {
                            players: [winner],
                            relation: 'defeats'
                        }
        res_obj[:teams][2] = {
                            players: [loser]
                        }

        create_result game, res_obj, create_date
    end


end
