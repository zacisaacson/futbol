require_relative 'test_helper'
require_relative '../lib/stat_tracker'
require_relative '../lib/games'
require_relative '../lib/teams'
require_relative '../lib/game_teams'

class SeasonStatsSupportTest < Minitest::Test

  def test_generate_difference
    assert_equal 0, @stat_tracker.generate_difference(0)
  end

  def test_generate_wins_by_coach
    assert_equal 00.0, @stat_tracker.generate_wins_by_coach(00.0)
  end

  def test_generate_games_in_season
    assert_equal "", @stat_tracker.generate_games_in_season("")
  end

  def test_generate_team_ratios
    assert_equal 00.0, @stat_tracker.generate_team_ratios(00.0)
  end

  def test_generate_tackles
    assert_equal 0, @stat_tracker.generate_tackles(0)
  end
end
