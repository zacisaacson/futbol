require_relative 'test_helper'
require_relative '../lib/stat_tracker'
require_relative '../lib/games'
require_relative '../lib/teams'
require_relative '../lib/game_teams'

class TeamStatsSupportTest < Minitest::Test

  def setup
    locations = { games: './data/games.csv', teams: './data/teams.csv', game_teams: './data/game_teams.csv' }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_generate_post_and_regular
    assert_equal ({}), @stat_tracker.generate_post_and_regular("18")
  end

  def test_worst_and_best_season

  end

  def test_best_and_worst_opponent

  end
end
