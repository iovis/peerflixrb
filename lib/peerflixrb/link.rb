require 'cgi'
require 'open-uri'

module Peerflixrb
  ##
  # Object that contains the info for a torrent file
  class Link
    def initialize(params)
      @params = params
    end

    def to_s
      filename
    end

    def filename
      @filename ||= "#{CGI.unescape(@params['name'])}.#{@params['extension']}"
    end

    def magnet
      @magnet ||= @params['magnet']
    end

    def info_hash
      @info_hash ||= extract_hash
    end

    private

    def extract_hash
      # Extract magnet properties to a Hash and then parse the sha1 info hash
      magnet_params = CGI.parse(URI.parse(magnet).query)
      magnet_params['xt'].first.match(/[0-9A-Fa-f]{20,}/).to_s.downcase
    end
  end
end
