require_relative 'test_helper'
require_relative '../lib/stat_tracker'
require_relative '../lib/games'
require_relative '../lib/teams'
require_relative '../lib/game_teams'
require_relative '../lib/generate_data'

class GenerateDataTest < MiniTest::Test

  def setup
    locations = { games: './data/dummy_games.csv', teams: './data/teams.csv', game_teams: './data/dummy_game_teams.csv' }
    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_generate_data
    p @stat_tracker.generate_data
    assert_instance_of Hash, @stat_tracker.generate_data
  end

end
