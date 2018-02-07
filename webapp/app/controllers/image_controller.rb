class ImageController < ApplicationController
    require 'socket'

    def index
        @ip = `hostname`
        puts "test"
        render 'index'
    end
end
