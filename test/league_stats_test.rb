require_relative 'test_helper'
require_relative '../lib/stat_tracker'
require_relative '../lib/games'
require_relative '../lib/teams'
require_relative '../lib/game_teams'

class LeagueStatsTest < MiniTest::Test

  def setup
    locations = { games: './data/games.csv', teams: './data/teams.csv', game_teams: './data/game_teams.csv' }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_count_of_teams
    assert_equal 32, @stat_tracker.count_of_teams
  end

  def test_best_offense
    assert_equal "Reign FC", @stat_tracker.best_offense
  end

  def test_worst_offense
    assert_equal "Utah Royals FC", @stat_tracker.worst_offense
  end

  def test_best_defense
    assert_equal "FC Cincinnati", @stat_tracker.best_defense
  end

  def test_worst_defense
    assert_equal "Columbus Crew SC", @stat_tracker.worst_defense
  end

  def test_highest_scoring_visitor
    assert_equal "FC Dallas", @stat_tracker.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "Reign FC", @stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "San Jose Earthquakes", @stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal "Utah Royals FC", @stat_tracker.lowest_scoring_home_team
  end

  def test_winningest_team
    assert_equal "Reign FC", @stat_tracker.winningest_team
  end

  def test_best_fans
    assert_equal "San Jose Earthquakes", @stat_tracker.best_fans
  end

  def test_worst_fans
    assert_equal ["Houston Dynamo"], @stat_tracker.worst_fans
  end

"---------------------------------SUPPORT METHOD TESTS------------------------"

  def test_generate_num_goals_per_team

    example = {
      "3" => 7,
      "6" => 11,
      "8" => 5,
      "9" => 9,
      "20" => 9,
      "24" => 15
    }

    assert_equal example, @stat_tracker.generate_num_goals_per_team
  end

  def test_generate_num_games_per_team

    example = {
      "3" => 4,
      "6" => 4,
      "8" => 3,
      "9" => 3,
      "20" => 5,
      "24" => 5
    }

    assert_equal example, @stat_tracker.generate_num_games_per_team
  end

  def test_generate_average
    averages = {
      "3" => 1.75,
      "6" => 2.75,
      "8" => 1.66,
      "9" => 3,
      "20" => 1.8,
      "24" => 3
    }

    averages_home = {
      "3" => 3.5,
      "6" => 5.5,
      "8" => 5,
      "9" => 4.5,
      "20" => 3,
      "24" => 7.5
    }

    averages_away = {
      "3" => 1.75,
      "6" => 5.5,
      "8" => 2.5,
      "9" => 9,
      "20" => 4.5,
      "24" => 5
    }
    assert_equal [averages, averages_home, averages_away], @stat_tracker.generate_average
  end

  def test_generate_allowed_goals
    home_goals = {
      "3" => 2,
      "6" => 2,
      "8" => 1,
      "9" => 2,
      "20" => 3,
      "24" => 2
    }

    away_goals = {
      "3" => 2,
      "6" => 2,
      "8" => 2,
      "9" => 1,
      "20" => 2,
      "24" => 3
    }

    example = [away_goals, home_goals]
    assert_equal example, @stat_tracker.generate_allowed_goals
  end

  def test_generate_average_allowed
    average_home = {
      "3" => 0.5,
      "6" => 0.5,
      "8" => 0.33,
      "9" => 0.66,
      "20" => 0.6,
      "24" => 0.4
    }

    average_away = {
      "3" => 0.5,
      "6" => 0.5,
      "8" => 0.66,
      "9" => 0.33,
      "20" => 0.4,
      "24" => 0.6
    }

    example [average_away, average_home]
    assert_equal example, @stat_tracker.generate_average_allowed
  end
#
  def test_generate_home_and_away_goals
    home_goals = {
      "3" => 2,
      "6" => 2,
      "8" => 1,
      "9" => 2,
      "20" => 3,
      "24" => 2
    }

    away_goals = {
      "3" => 2,
      "6" => 2,
      "8" => 2,
      "9" => 1,
      "20" => 2,
      "24" => 3
    }

    example = [away_goals, home_goals]

    assert_equal example, @stat_tracker.generate_home_and_away_goals
  end

  def test_highest_scoring_visitor
    assert_equal "24", @stat_tracker.highest_scoring_visitor
  end

  def test_highest_scoring_home_team
    assert_equal "20", @stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    assert_equal "9", @stat_tracker.lowest_scoring_visitor
  end

  def test_lowest_scoring_home_team
    assert_equal "8", @stat_tracker.lowest_scoring_home_team
  end

  def test_generate_wins

    team_wins = {
      "3" => 0,
      "6" => 4,
      "8" => 0,
      "9" => 2,
      "20" => 0,
      "24" => 5
    }

    home_wins = {
      "3" => 0,
      "6" => 2,
      "8" => 0,
      "9" => 2,
      "20" => 0,
      "24" => 2
    }

    away_wins = {
      "3" => 0,
      "6" => 2,
      "8" => 0,
      "9" => 0,
      "20" => 0,
      "24" => 3
    }

    example [team_wins, home_wins, away_wins]
    assert_equal example, @stat_tracker.generate_wins
  end

  def test_calculate_percents
    percent_away = {
      "3" => 0,
      "6" => 5.0,
      "8" => 0,
      "9" => 0,
      "20" => 0,
      "24" => 16.66
    }

    percent_home = {
      "3" => 0,
      "6" => 5.0,
      "8" => 0,
      "9" => 6.66,
      "20" => 0,
      "24" => 4
    }

    percent_team = {
      "3" => 0,
      "6" => 100,
      "8" => 0,
      "9" => 66.66,
      "20" => 0,
      "24" => 100
    }

    example = [percent_away, percent_home, percent_team]
    assert_equal example, @stat_tracker.calculate_percents
  end
end
