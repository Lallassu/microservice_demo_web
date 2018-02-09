class BadSanta
    include HTTParty
    def initialize
        self.class.base_uri "#{ENV['HOST_IP']}:6000"
        self.class.default_timeout 10
    end

    def login(user, pass) 
        body = {
            "user" => user,
            "pass" => pass,
        }
        resp = self.class.post("/login", :body => body)
        return resp.parsed_response
    end

    def servers
        resp = self.class.get("/servers")
        return resp.parsed_response
    end

    def toplist
        resp = self.class.get("/toplist")
        return resp.parsed_response
    end
end

