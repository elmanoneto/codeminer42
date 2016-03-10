class GamesLog

  def initialize
    @log = IO.readlines('games.log')
    @games = {}
    @players = {}
  end

  def parse
    game = 0
    kill = 0
    list = []

    for i in @log

      # init game
      if i.include? 'InitGame'
        kill = 0
        game += 1
        players_list = []
        kills_list = []
      end

      # add player in list
      if i.include? 'ClientUserinfoChanged'
        start = "n\\\\"
        finish = "\\\\"
        players_list << i[/#{start}(.*?)#{finish}/m, 1]
      end

      # filter who killed who
      if i.include? 'Kill'
        start = ":"
        finish = " killed"
        if i[13..-1][/#{start}(.*?)#{finish}/m, 1].delete(' ') != '<world>'
          kills_list << i[13..-1][/#{start}(.*?)#{finish}/m, 1].delete(' ')
        else
          start = "killed"
          finish = "by"
          player = i[/#{start}(.*?)#{finish}/m, 1].delete(' ')
          kills_list.delete(player) if kills_list.include? player
        end
        kill += 1
      end

      if game == 0 then next end

      @players[game] = list
      @games["game_#{game}"] = {players: players_list.uniq, total_kills: kill, kills: count_duplicates(kills_list)}

    end
  end

  def ranking
    for i in @games
      puts '---'
      puts "Ranking: #{i[0]}"
      puts i[1][:kills].sort_by {|_key, value| value}.reverse
      puts "Hash: #{i[1][:kills]}"
    end
  end

  def get_games
    @games
  end

  def get_players
    @players
  end

  private

  def count_duplicates array
    hash = Hash.new(0)
    array.each {|i| hash.store(i, hash[i]+1)}
    hash
  end

end

game = GamesLog.new
game.parse
game.ranking
