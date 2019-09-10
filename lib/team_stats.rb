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
    game_ids.uniq
    game_ids.each do |game_id|
      if @games[game_id].type == "Postseason" && !post_and_reg.has_key?(@games[game_id].season)
        post_and_reg[@games[game_id].season] = {}
        post_and_reg[@games[game_id].season][:post_season] = [game_id]
      elsif @games[game_id].type == "Postseason" && post_and_reg.has_key?(@games[game_id].season) && !post_and_reg[(@games[game_id].season)].has_key?(:post_season)
        post_and_reg[@games[game_id].season][:post_season] = [game_id]
      elsif @games[game_id].type == "Postseason" && post_and_reg.has_key?(@games[game_id].season) && post_and_reg[(@games[game_id].season)].has_key?(:post_season)
        post_and_reg[@games[game_id].season][:post_season] << game_id
      elsif @games[game_id].type == "Regular Season" && !post_and_reg.has_key?(@games[game_id].season)
        post_and_reg[@games[game_id].season] = {}
        post_and_reg[@games[game_id].season][:regular_season] = [game_id]
      elsif @games[game_id].type == "Regular Season" && post_and_reg.has_key?(@games[game_id].season) && !post_and_reg[(@games[game_id].season)].has_key?(:regular_season)
        post_and_reg[@games[game_id].season][:regular_season] = [game_id]
      elsif @games[game_id].type == "Regular Season" && post_and_reg.has_key?(@games[game_id].season) && post_and_reg[(@games[game_id].season)].has_key?(:regular_season)
        post_and_reg[@games[game_id].season][:regular_season] << game_id
      end
    end
    post_and_reg
  end

  def generate_per_season_hash(team_id)
    post_and_reg = generate_post_and_regular(team_id)
    # post_and_reg.each do |season, hash|
    #   hash.each do |reg_or_post, gameids_array|
    #     gameids_array.each do |game_id|
    # game_ids = []
    # @game_teams[team_id].each {|game| game_ids << game.game_id}
    # game_ids.uniq                       @games(gameids_array.sample).season
    # game_teams = @game_teams.select {|team, array| team == team_id }
    # game_teams = game_teams.select {|game| @games[game.game_id].season ==   game }
    # selected_games = game_teams.select {|team, array| }


+{"20162017"=>{:regular_season=>["2016030171", "2016030174"], :post_season=>["2016030172", "2016030173"]}, "20142015"=>{:post_season=>["2014030243"]}}

    selected = { :post => [], :regular => []}
    post_and_reg.each do |season, hash|
      hash.each do |reg_or_post, gameids_array|
        if reg_or_post == :postseason
          selected_games = @game_teams.select {|game_id, game_objs| gameids_array.include?(game_id)}
          gameids_array.each do |game_id|
            if @games[game_id].type == "Postseason"
              # selected_games = selected_games.select {|game_id, game_objs| @games[]}
              post_and_reg[@games[game_id].season][:postseason][:win_percentage] = calculate_win_percent(selected_games)
              post_and_reg[@games[game_id].season][:postseason][:total_goals_scored] = generate_num_goals_per_team(selected_games)
              post_and_reg[@games[game_id].season][:postseason][:total_goals_against] = generate_allowed_goals(game_teams[team_id])
              post_and_reg[@games[game_id].season][:postseason][:average_goals_scored] = generate_average_goals(selected_games)
              post_and_reg[@games[game_id].season][:postseason][:average_goals_against]= generate_average_allowed(selected_games, game_teams[team_id])
            end
          end
      end
      post_and_reg.each do |season, hash|
        hash.each do |reg_or_post, gameids_array|
          if reg_or_post == :regular_season
            selected_games = @game_teams.select {|game_id, game_objs| gameids_array.include?(game_id) }
              gameids_array.each do |game_id|
            if @games[game_id].type == "Regular Season"
              # selected_games = @game_teams.select {|game_id, game_objs| gameids_array.include?(game_id)}
              post_and_reg[@games[game_id].season][:regular_season][:win_percentage] = calculate_win_percent(selected_games)
              post_and_reg[@games[game_id].season][:regular_season][:total_goals_scored] = generate_num_goals_per_team(selected_games)
              post_and_reg[@games[game_id].season][:regular_season][:total_goals_against] = generate_allowed_goals(game_teams[team_id])
              post_and_reg[@games[game_id].season][:regular_season][:average_goals_scored] = generate_average_goals(selected_games)
              post_and_reg[@games[game_id].season][:regular_season][:average_goals_against] = generate_average_allowed(selected_games, game_teams[team_id])
            end
          end
        end
      end
      post_and_reg
  end
    # selected_games = game_teams.select {|game| @games[game.game_id].season == SEASON?}




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
      # require "pry"; binding.pry
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
