require_relative 'test_helper'
require_relative '../lib/stat_tracker'
require_relative '../lib/games'
require_relative '../lib/teams'
require_relative '../lib/game_teams'

class TeamStatsSupportTest < Minitest::Test

  def setup
    locations = { games: './data/dummy_games.csv', teams: './data/teams.csv', game_teams: './data/dummy_game_teams.csv' }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_generate_post_and_regular
    example = {"20122013"=>{:postseason=>["2012030221", "2012030222", "2012030223",
       "2012030224"], :regular_season=>[]}, "20162017"=>{:postseason=>[],
       :regular_season=>[]}, "20142015"=>{:postseason=>[], :regular_season=>[]}
      }
    assert_equal example, @stat_tracker.generate_post_and_regular("3")
  end

  def test_generate_win_percentage_by_post_and_reg_per_season
    team_6_win_percentage = {"20122013"=>{:postseason=>["2012030221", "2012030222",
       "2012030223", "2012030224"], :regular_season=>[]}, "20162017"=>{:postseason=>[],
          :regular_season=>[]}, "20142015"=>{:postseason=>[], :regular_season=>[]}}

    assert_equal team_6_win_percentage, @stat_tracker.generate_post_and_regular("6")
  end

  def test_generate_goals_difference
    min = -1
    max = -1
    assert_equal [min, max],@stat_tracker.generate_goals_difference("3")
  end

  def test_generate_opponents_wins_and_games

    opponent_wins = {
      "6" => 4,
    }

    opponent_games = {
      "6" => 4,
    }

    team_wins = {
      "6" => 0,
     }

    assert_equal [{"6"=>4}, {"6"=>4}, {"6"=>0}], @stat_tracker.generate_opponents_wins_and_games("3")
  end

  def test_generate_percent
    #"3" apponent is "6" so this example will be based off of "6" scores.
    min_percent = {
      "6" => 0.0
    }

    max_percent = {
      "6" => 100.0
    }

    assert_equal ["FC Dallas", "FC Dallas", max_percent, min_percent],@stat_tracker.generate_percent("3")
  end

  def test_worst_and_best_season
    seasons = {
      "20142015" => 100.00,
      "20162017" => 100.00
    }

    assert_equal ["20162017", "20162017", seasons], @stat_tracker.worst_and_best_season("24")
  end
end
