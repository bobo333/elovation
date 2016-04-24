# create players

years = ['85_86', '86_87', '95_96', '15_16']

years.each do |year|
    teams_file = File.open("/elovation/nba_data/csv/#{year}/teams.csv", 'r')
    teams_file.each_line do |line|
        name = "#{year} #{line.chomp}"

        Player.new(name: name).save
    end
    teams_file.close
end
