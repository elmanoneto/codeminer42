require 'minitest/autorun'
require_relative '../games_log'

class GamesLogTest < Minitest::Test

  def setup
    @game = GamesLog.new
    @game.parse
    @game.ranking
    @game.kills_report
  end

  def test_instance_game
    assert_instance_of GamesLog, @game
  end

  def test_instance_log
    assert_instance_of Array, @game.get_log
  end

  def test_instance_ranking
    assert_instance_of Hash, @game.get_ranking
  end

  def test_instance_kills_report
    assert_instance_of Hash, @game.get_kills_report
  end

  def test_empty_log
    assert_respond_to @game.get_log, :empty?
    assert !@game.get_log.empty?, 'Log is empty.'
  end

  def test_empty_games
    assert_respond_to @game.get_games, :empty?
    assert !@game.get_games.empty?, 'Games is empty'
  end

  def test_empty_kills_report
    assert_respond_to @game.get_kills_report, :empty?
    assert !@game.get_kills_report.empty?, 'Kills is empty'
  end

  def test_empty_ranking
    assert_respond_to @game.get_ranking, :empty?
    assert !@game.get_ranking.empty?, 'Ranking is empty'
  end

end
