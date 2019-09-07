module LeagueStats

  def count_of_teams
    @teams.length
  end

  def best_offense
    max = generate_average.max_by {|team,average| average }
    @teams[max[0]].teamName
  end

  def worst_offense
    min = generate_average.min_by {|team,average| average }

    @teams[min[0]].teamName
  end

  def generate_num_goals_per_team
    return @goals_per_team unless @goals_per_team.nil?
    @goals_per_team = Hash.new(0)
    @game_teams.each do |id, array|
      @goals_per_team[array[0].team_id] += array[0].goals
    end
    @goals_per_team
  end

  def generate_num_games_per_team
    return @games_per_team unless @games_per_team.nil?
    @games_per_team = Hash.new(0)
    @game_teams.each do |id, array|
      @games_per_team[array[0].team_id] += 1
    end
    @games_per_team
  end

  def generate_average
    averages = {}
    generate_num_goals_per_team.each do |team, goals|
      averages[team] = goals / generate_num_games_per_team[team]
    end
  end

  def best_defense
    min = generate_average_allowed.min_by {|team, allowed| allowed }[0]
    @teams[min].teamName
  end

  def worst_defense
    max = generate_average_allowed.max_by {|team, allowed| allowed }[0]
    @teams[max].teamName
  end

  def generate_allowed_goals
    allowed_goals = Hash.new(0)
    @games.each do |id, obj|
      allowed_goals[obj.home_team_id] += obj.away_goals
      allowed_goals[obj.away_team_id] += obj.home_goals
    end
    allowed_goals
  end

  def generate_average_allowed
    averages = {}
    generate_allowed_goals.each do |team, allowed|
      averages[team] = allowed / generate_num_games_per_team[team]
    end
    averages
  end

  def generate_home_and_away_goals
    return @home_and_away_goals unless @home_and_away_goals.nil?
    @home_and_away_goals = [Hash.new(0), Hash.new(0)]
    @games.each do |team_id, object|
      @home_and_away_goals[0][object.away_team_id] += object.away_goals
      @home_and_away_goals[1][object.home_team_id] += object.home_goals
    end
    @home_and_away_goals
  end

  def highest_scoring_visitor
    max = generate_home_and_away_goals[0].max_by {|id, goals| goals}[0]
    @teams[max].teamName
  end

  def highest_scoring_home_team
    max = generate_home_and_away_goals[1].max_by {|id, goals| goals}[0]
    @teams[max].teamName
  end

  def lowest_scoring_visitor
    min = generate_home_and_away_goals[0].min_by {|id, goals| goals}[0]
    @teams[min].teamName
  end

  def lowest_scoring_home_team
    min = generate_home_and_away_goals[1].min_by {|id, goals| goals}[0]
    @teams[min].teamName
  end

  def generate_wins
    return @wins unless @wins.nil?
    @wins_by_team = Hash.new(0)
    @wins_by_home = Hash.new(0)
    @wins_by_away = Hash.new(0)
    @wins = [@wins_by_away, @wins_by_home, @wins_by_team]

    @game_teams.each do |id, array|
      if array[0].result == "WIN"
        @wins_by_team[id] += 1
      end
      if array[0].result == "WIN" && array[0].hoa == "away"
        @wins_by_away[id] += 1
      end
      if array[0].result == "WIN" && array[0].hoa == "home"
        @wins_by_home[id] += 1
      end
    end
    @wins
  end

  def calculate_percents
      return @percents unless @percents.nil?
      @percent_by_away = {}
      @percent_by_home = {}
      @percent_by_team = {}
      @percents = [@percent_by_away, @percent_by_home, @percent_by_team]
      generate_wins[0].each do |k,v|
        @percent_by_away[k] = v / generate_num_games_per_team[v]
      end
      generate_wins[1].each do |k,v|
        @percent_by_home[k] = v / generate_num_games_per_team[v]
      end
      generate_wins[2].each do |k,v|
        @percent_by_team[k] = v / generate_num_games_per_team[v]
      end
      @percents
  end

  def winningest_team
    highest = calculate_percents[2].max_by {|id, percent| percent}
    @teams[highest].teamName
  end

# Name of team with biggest difference between home and away win percentages -string
  def best_fans


  end

# List of names of all teams with better away records(wins) than home records(wins) -array
  def worst_fans

  end
end