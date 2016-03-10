require_relative 'games_log'

game = GamesLog.new
game.parse

puts 'Games'
game.show_games

puts ' '
puts 'Ranking'
game.show_ranking

puts ' '
puts 'Kills Report'
game.show_kills_report
