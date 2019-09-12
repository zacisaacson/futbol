module SeasonStats
# season id as argument
# sort by the regular season
# # find how many games they played
# @games[game_id].season
# find how many games they won
#sort by their post season
# find how many games they won
#Team with biggest decrease between regular and post season win percentage
  def biggest_bust(season)
    min= generate_difference(season).min_by {|team,  difference| difference }[0]
    @teams[min].teamName
  end

  def biggest_surprise(season)
    max = generate_difference(season).max_by {|team, difference| difference }[0]
    @teams[max].teamName
  end

  def winningest_coach(season)
    max = generate_wins_by_coach(season).max_by {|coach, percent| percent}[0]
    max
  end

  def worst_coach(season)
    min = generate_wins_by_coach(season).min_by {|coach, percent| percent}[0]
    min
  end

  def most_accurate_team(season)
    max = generate_team_ratios(season).max_by { |team, ratio| ratio}[0]
    @teams[max].teamName
  end

  def least_accurate_team(season)
    min = generate_team_ratios(season).min_by { |team, ratio| ratio}[0]
    @teams[min].teamName
  end

  def most_tackles(season)
    max = generate_tackles(season).max_by {|team, tackles| tackles}[0]
    @teams[max].teamName
  end

  def fewest_tackles(season)
    min = generate_tackles(season).min_by {|team, tackles| tackles}[0]
    @teams[min].teamName
  end

"-----------------------------SUPPORT METHODS----------------------------------"

  def generate_difference(season)
    team_ids = []
    @game_teams.each do |team_id, array|
      team_ids << team_id
    end
    difference = {}
    team_ids.uniq.each do |id|
      difference[id] = (seasonal_summary(id)[season][:postseason][:win_percentage] - seasonal_summary(id)[season][:regular_season][:win_percentage])
    end
    difference
  end

  def generate_wins_by_coach(season)
    coach_wins = Hash.new(0)
    coach_games = Hash.new(0)
    coach_win_percent = {}
    games = []
    @games.each do |game_id, game|
      if game.season == season
        games << game_id
      end
    end
    game_teams = generate_games_in_season(season)
    games.each do |game_id, game|
      team_ids = []
      team_ids << @games[game_id].home_team_id
      team_ids << @games[game_id].away_team_id
      game_teams.each do |game|
        if team_ids.include?(game.team_id) && games.include?(game.game_id)
          if game.result == "WIN"
            coach_wins[game.head_coach] += 1
            coach_games[game.head_coach] += 1
          elsif game.result != "WIN"
            coach_wins[game.head_coach] += 0
            coach_games[game.head_coach] += 1
          end
        end
      end
    end
    coach_games.each do |coach, game_num|
      coach_win_percent[coach] = (coach_wins[coach].to_f / coach_games[coach])
    end
    coach_win_percent
  end

  def generate_games_in_season(season)
    games = []
    @games.each do |game_id, game|
      if game.season == season
        games << game_id
      end
    end
    game_teams = []
    @game_teams.each do |team_id, array|
      array.each do |game|
        if games.include?(game.game_id)
          game_teams << game
        end
      end
    end
    game_teams
  end

  def generate_team_ratios(season)
    team_shots = Hash.new(0)
    team_ratios = {}
    team_goals = Hash.new(0)
    game_teams = generate_games_in_season(season)
    game_teams.each do |game|
      team_shots[game.team_id] += game.shots
      team_goals[game.team_id] += game.goals
    end
    team_goals.each do |team, goals|
      team_ratios[team] = (goals.to_f / team_shots[team])
    end
    team_ratios
  end

  def generate_tackles(season)
    tackles = Hash.new(0)
    game_teams = generate_games_in_season(season)
    game_teams.each do |game|
      tackles[game.team_id] += game.tackles
    end
    tackles
  end
end
