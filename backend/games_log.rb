class GamesLog

  def initialize
    @log = IO.readlines('games.log')
    @games = {}
    @ranking = {}
    @report = {}
  end

  def parse
    game = 0

    for i in @log

      # init game
      if i.include? 'InitGame'
        kill = 0
        game += 1
        players_list = []
        kills_list = []
        kills_by_means_list = []
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

      # filter means of death
      if i.include? 'Kill'
        start = "by"
        kills_by_means_list << i.partition('by').last.delete!(' ') .delete!("\n")
      end

      if game == 0 then next end

      @games["game_#{game}"] = {
        players: players_list.uniq,
        total_kills: kill,
        kills: count_duplicates(kills_list),
        kills_by_means: count_duplicates(kills_by_means_list)
      }

    end
  end

  def ranking
    for i in @games
      puts '---'
      puts "Ranking: #{i[0]}"
      puts i[1][:kills].sort_by {|_key, value| value}.reverse
      puts "Hash: #{i[1][:kills]}"
      @ranking["game_#{i[0]}"] = i[1][:kills].sort_by {|_key, value| value}.reverse
    end
  end

  def kills_report
    for i in @games
      puts '---'
      puts i[0]
      puts i[1][:kills_by_means]
      @report["game_#{i[0]}"] = i[1][:kills_by_means]
    end
  end

  def get_ranking
    @ranking
  end

  def get_kills_report
    @report
  end

  def get_games
    @games
  end

  def get_log
    @log
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
game.kills_report
game.ranking
