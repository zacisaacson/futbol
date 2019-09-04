class Game
  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals,
              :venue,
              :venue_link

    def initialize(line)
      @game_id = line.split(",")[0].to_i
      @season = line.split(",")[1].to_i
      @type = line.split(",")[2]
      @date_time = line.split(",")[3]
      @away_team_id = line.split(",")[4].to_i
      @home_team_id = line.split(",")[5].to_i
      @away_goals = line.split(",")[6].to_i 
      @home_goals = line.split(",")[7].to_i
      @venue = line.split(",")[8]
      @venue_link = line.split(",")[9]
    end





end