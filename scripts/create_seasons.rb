# create seasons

years = ['85_86', '86_87', '95_96', '15_16']

years.each do |year|
    year_string = year.sub('_', '-')
    season = Game.new    name: "#{year_string} Season",
                min_number_of_players_per_team: 1,
                max_number_of_players_per_team: 1,
                rating_type: "elo",
                min_number_of_teams: 2,
                max_number_of_teams: 2,
                allow_ties: false
    season.save
end

