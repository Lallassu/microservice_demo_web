class GameController < ApplicationController
    protect_from_forgery with: :null_session
    require 'BadSanta'

    def index
        @ip = `hostname`
        render 'index'
    end

    def login
        b = BadSanta.new
        render json: b.login(params["user"], params["pass"]).to_json
    end

    def toplist
        b = BadSanta.new
        render json: b.toplist.to_json
    end

    def servers
        b = BadSanta.new
        render json: b.servers.to_json
    end

end
