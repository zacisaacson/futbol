module TeamStats

  def team_info(team_id)
    info = {}
    info["team_id"] = @teams[team_id].team_id
    info["franchiseId"] = @teams[team_id].franchiseId
    info["teamName"] = @teams[team_id].teamName
    info["abbreviation"] = @teams[team_id].abbreviation
    info["link"] = @teams[team_id].link
    info
  end


  def best_season(team_id)
    worst_and_best_season(team_id)[1]
  end

  def worst_season(team_id)
    worst_and_best_season(team_id)[0]
  end

  def average_win_percentage(team_id)
    (calculate_percents[2][team_id]/100).round(2)
  end

  def most_goals_scored(team_id)
    @game_teams[team_id].max_by{ |object| object.goals }.goals
  end

  def fewest_goals_scored(team_id)
    @game_teams[team_id].min_by{ |object| object.goals }.goals
  end

  def favorite_opponent(team_id)
    generate_percent(team_id)[0]
  end

  def rival(team_id)
    generate_percent(team_id)[1]
  end


  def biggest_team_blowout(team_id)
    generate_goals_difference(team_id)[0]
  end

  def worst_loss(team_id)
    generate_goals_difference(team_id)[1].abs
  end

  def head_to_head(team_id)
    opponents_and_win_percentage = {}
    generate_percent(team_id)[3].each do |opponent, percent|
      opponents_and_win_percentage[@teams[opponent].teamName] = (percent/100).round(2)
    end
    opponents_and_win_percentage
  end

  def seasonal_summary(team_id)
    summary = {}
    @game_teams[team_id].each do |game|
      summary[@games[game.game_id].season]
      summary[@games[game.game_id].season]
    end
  end

  def generate_post_and_regular(team_id)
    game_ids = []
    post_and_reg = {}
    @game_teams[team_id].each {|game| game_ids << game.game_id}
    game_ids.each do |game_id|
      if @games[game_id].type == "Postseason" && !post_and_reg.has_key?(@games[game_id].season)
        post_and_reg[@games[game_id].season] = {}
        post_and_reg[@games[game_id].season][:postseason] = [game_id]
      elsif @games[game_id].type == "Postseason" && post_and_reg.has_key?(@games[game_id].season)
        post_and_reg[@games[game_id].season][:postseason] = [] unless post_and_reg[@games[game_id].season].has_key?(:postseason)
        post_and_reg[@games[game_id].season][:postseason] << game_id
      elsif @games[game_id].type == "Regular Season" && !post_and_reg.has_key?(@games[game_id].season)
        post_and_reg[@games[game_id].season] = {}
        post_and_reg[@games[game_id].season][:regular_season] = [game_id]
      elsif @games[game_id].type == "Regular Season" && post_and_reg.has_key?(@games[game_id].season)
        post_and_reg[@games[game_id].season][:regular_season] = [] unless post_and_reg[@games[game_id].season].has_key?(:regular_season)
        post_and_reg[@games[game_id].season][:regular_season] << game_id
      end
    end
    post_and_reg
  end

  def seasonal_summary(team_id)
    generate_inner_hash_for_summary(team_id)
  end

  def generate_inner_hash_for_summary(team_id)
    summary_hash = {}
    post_and_reg = generate_post_and_regular(team_id)
    post_and_reg.each do |season, hash|
      summary_hash[season] = {} unless summary_hash.key? season
      hash.each do |reg_or_post, game_ids|
        summary_hash[season][reg_or_post] = {} unless summary_hash[season].key? reg_or_post
        game_teams = []
        @game_teams.each do |team, array|
          array.each do |game|
            if game_ids.include?(game.game_id) && game.team_id == team_id
              game_teams << game
            end
          end
        end
        games = @games.select {|game_id, game| game_ids.include?(game_id) }
          summary_hash[season][reg_or_post][:win_percentage] = win_percent(game_teams)
          summary_hash[season][reg_or_post][:total_goals_scored] = goals(game_teams)
          summary_hash[season][reg_or_post][:total_goals_against] = allowed_goals(team_id,games)
          summary_hash[season][reg_or_post][:average_goals_scored] = generate_average(goals(game_teams), game_num(game_teams))
          summary_hash[season][reg_or_post][:average_goals_against] = generate_average(allowed_goals(team_id, games),game_num(game_teams))
      end
    end
    summary_hash
  end

  def win_percent(game_teams)
    (wins(game_teams).to_f/game_num(game_teams)).round(2)
  end

  def wins(game_teams)
    results = []
    game_teams.each do |game|
      results << game.result
    end
    results.count("WIN")
  end

  def game_num(game_teams)
    game_num = 0
    game_teams.each do |game|
      game_num += 1
    end
    game_num
  end


  def goals(game_teams)
    goals = 0
    game_teams.each do |game|
        goals += game.goals
    end
    goals
  end

  def allowed_goals(team_id, games)
    allowed = 0
    games.each do |game_id, game|
      if game.home_team_id == team_id
        allowed += game.away_goals
      elsif game.away_team_id == team_id
        allowed += game.home_goals
      end
    end
    allowed
  end


  def generate_average(num,divisor)
    (num/divisor.to_f).round(2)
  end

  def generate_goals_difference(team_id)
    game_teams = @game_teams[team_id]
    games = []
    game_teams.each { |game| games << @games[game.game_id] }
    goals = {}
    games.each do |game|
      goals[game.game_id] = {
        :team_goals => 0,
        :opponent_goals => 0 }
    end
    games.each do |game|
      if team_id == game.home_team_id
        goals[game.game_id][:team_goals] = game.home_goals
        goals[game.game_id][:opponent_goals] = game.away_goals
      elsif team_id == game.away_team_id
        goals[game.game_id][:team_goals] = game.away_goals
        goals[game.game_id][:opponent_goals] = game.home_goals
      end
    end
    differences = {}
    goals.each do |game_id, goals_hash|
      differences[game_id] = goals[game_id][:team_goals] - goals[game_id][:opponent_goals]
    end
    max = differences.max_by {|game_id, difference| difference}[1]
    min = differences.min_by {|game_id, difference| difference}[1]
    [max,min]
  end

  def generate_opponents_wins_and_games(team_id)
    opponent_games = Hash.new(0)
    opponent_wins = Hash.new(0)
    team_wins = Hash.new(0)
    @games.each do |game_id, game|
      if team_id == game.home_team_id && game.away_goals > game.home_goals
        opponent_games[game.away_team_id] += 1
        opponent_wins[game.away_team_id] += 1
        team_wins[game.away_team_id] += 0
      elsif team_id == game.home_team_id && game.away_goals < game.home_goals
        opponent_games[game.away_team_id] += 1
        opponent_wins[game.away_team_id] += 0
        team_wins[game.away_team_id] += 1
      elsif team_id == game.home_team_id && game.away_goals == game.home_goals
        opponent_games[game.away_team_id] += 1
        opponent_wins[game.away_team_id] += 0
        team_wins[game.away_team_id] += 0
      end
      if team_id == game.away_team_id && game.home_goals > game.away_goals
        opponent_games[game.home_team_id] += 1
        opponent_wins[game.home_team_id] += 1
        team_wins[game.home_team_id] += 0
      elsif team_id == game.away_team_id && game.home_goals < game.away_goals
        opponent_games[game.home_team_id] += 1
        opponent_wins[game.home_team_id] += 0
        team_wins[game.home_team_id] += 1
      elsif team_id == game.away_team_id && game.home_goals == game.away_goals
        opponent_games[game.home_team_id] += 1
        opponent_wins[game.home_team_id] += 0
        team_wins[game.home_team_id] += 0
      end
    end
    [opponent_wins, opponent_games,team_wins]
  end

  def generate_percent(team_id)
    opponent_wins = generate_opponents_wins_and_games(team_id)[0]
    opponent_games = generate_opponents_wins_and_games(team_id)[1]
    team_wins = generate_opponents_wins_and_games(team_id)[2]
    opponent_percent = {}
    team_percent = {}
    opponent_wins.each {|opponent, wins| opponent_percent[opponent] = ((wins.to_f / opponent_games[opponent]) * 100).round(2) }
    opponent_wins.each {|opponent, wins| opponent_percent[opponent] = ((wins.to_f / opponent_games[opponent]) * 100).round(2) }
    opponent_games.each {|opponent, games| team_percent[opponent] = ((team_wins[opponent].to_f / games) * 100).round(2) }
    min = opponent_percent.min_by{ |opp, percent| percent }[0]
    max = opponent_percent.max_by{ |opp, percent| percent }[0]
    min_team = @teams[min].teamName
    max_team = @teams[max].teamName
    # require "pry"; binding.pry
    [min_team, max_team, opponent_percent,team_percent]
  end

  def worst_and_best_season(team_id)
    seasons = Hash.new(0)
    game_ids = []
    @game_teams[team_id].each {|game| game_ids << game.game_id}
    @game_count_by_season = Hash.new(0)
    game_ids.each do |game_id|
      if @games[game_id].home_team_id == team_id
        @game_count_by_season[@games[game_id].season] += 1
        if @games[game_id].home_goals > @games[game_id].away_goals
          seasons[@games[game_id].season] += 1
        end
      elsif @games[game_id].away_team_id == team_id
        @game_count_by_season[@games[game_id].season] += 1
        if @games[game_id].away_goals > @games[game_id].home_goals
          seasons[@games[game_id].season] += 1
        end
      end
    end
    seasons = seasons.each do |season, wins|
      seasons[season] = ((wins.to_f / @game_count_by_season[season]) * 100).round(2)
    end
    max = seasons.max_by {|id, count| count}[0]
    min = seasons.min_by {|id, count| count}[0]
    @min_max = [min, max, seasons]
  end


end
