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

  def generate_difference(season)
    team_ids = []
    @game_teams.each do |team_id, array|
      team_ids << team_id
    end
    difference = {}
    team_ids.uniq.each do |id|
      difference[id] = (seasonal_summary(id)[season][:postseason][:win_percentage] - seasonal_summary(id)[season][:regular_season][:win_percentage]).round(2)
    end
    difference
  end

  def biggest_surprise(season)
    require "pry"; binding.pry
    max = generate_difference(season).max_by {|team, difference| difference }[0]
    @teams[max].teamName
  end

  def winningest_coach(season)
  end

  def worst_coach(season)
  end

  def most_accurate_team(season)
  end

  def least_accurate_team(season)
  end

  def most_tackles(season)
  end

  def fewest_tackles(season)
  end





end
