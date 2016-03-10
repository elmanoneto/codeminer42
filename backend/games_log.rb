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
        list = []
        kills = []
      end

      # add player in list
      if i.include? 'ClientUserinfoChanged'
        start = "n\\\\"
        finish = "\\\\"
        list << i[/#{start}(.*?)#{finish}/m, 1]
      end

      # filter who killed who
      if i.include? 'Kill'
        start = ":"
        finish = " killed"
        if i[13..-1][/#{start}(.*?)#{finish}/m, 1].delete(' ') != '<world>'
          kills << i[13..-1][/#{start}(.*?)#{finish}/m, 1].delete(' ')
        else
          start = "killed"
          finish = "by"
          player = i[/#{start}(.*?)#{finish}/m, 1].delete(' ')
          kills.delete(player) if kills.include? player
        end
        kill += 1
      end

      if game == 0 then next end

      @players[game] = list
      @games["game_#{game}"] = {players: list.uniq, total_kills: kill, kills: count_duplicates(kills)}
    end
  end

  def count_duplicates array
    hash = Hash.new(0)
    array.each { |i| hash.store(i, hash[i]+1) }
    hash
  end

  def get_games
    @games
  end

  def get_players
    @players
  end

end
