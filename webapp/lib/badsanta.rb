class BadSanta
    def initialize
        #@db = Mysql2::Client.new(:host => ENV["HOST_IP"],
        #                         :username => root, 
        #                         :password => ENV["HOST_IP"],
        #                         :database => "badsanta")
        @db = Mysql2::Client.new(:host => "localhost",
                                 :username => "game_", 
                                 :password => "game_",
                                 :database => "badsanta")
    end

    def close
        @db.close
    end

    def login(user, pass) 
        if user == "" || pass == ""
            return {:status => false}
        end
        id = 0
        q = @db.prepare('select * from players where name = ? and password = ?')
        res = q.execute(user, pass)
        kills = 0
        deaths = 0
        last_played_ts = 0
        created_ts = 0
        if res.count > 0
            id = SecureRandom.hex
            kills = res.first["kills"]
            deaths = res.first["deaths"]
            created_ts = DateTime.strptime("#{res.first["created_ts"]}",'%s').strftime("%Y-%m-%d %H:%M:%S")
            last_played_ts = DateTime.strptime("#{res.first["last_played_ts"]}",'%s').strftime("%Y-%m-%d %H:%M:%S")
        else 
            # New user?
            q = @db.prepare('select name from players where name = ?')
            res = q.execute(user)
            if res.count == 0
                id = SecureRandom.hex
                q = @db.prepare('insert into players set name = ?, password = ?, kills = 0, deaths = 0, created_ts = unix_timestamp(), last_played_ts = unix_timestamp()')
                q.execute(user, pass)
            end
        end
        if id != 0
            q = @db.prepare('update players set player_id = ? where name = ?')
            q.execute(id, user)
            close
            return {:status => true, :id => id, :kills => kills, :deaths => deaths, :last_played => last_played_ts, :created => created_ts}
        end
        close
        return {:status => false}
    end

    def servers
        q = @db.prepare('select name, hostname from servers where up = 1')
        res = q.execute
        servers = []
        res.each do |r|
            servers.push(r)
        end
        close
        return servers
    end

    def toplist
        q = @db.prepare('select name, kills, deaths, last_played_ts, created_ts from players order by kills desc limit 20')
        res = q.execute
        players = []
        res.each do |r|
            r["last_played"] = DateTime.strptime("#{r["last_played_ts"]}", "%s").strftime("%Y-%m-%d %H:%M:%S")
            r["created"] = DateTime.strptime("#{r["created_ts"]}", "%s").strftime("%Y-%m-%d %H:%M:%S")
            players.push(r)
        end
        close
        return players
    end
end

