class ImageController < ApplicationController
    require 'socket'

    def index
        @ip = `hostname`
        render 'index'
    end
end
