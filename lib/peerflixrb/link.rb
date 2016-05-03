require 'cgi'
require 'open-uri'

module Peerflixrb
  ##
  # Object that contains the info for a torrent file
  class Link
    @@max_length_name ||= 0

    attr_reader :seeders, :leechers

    def initialize(params)
      @params = params
      @seeders = params['seeders']
      @leechers = params['leechers']

      # Get the longest filename for pretty print
      set_max_length_name(filename.length)
    end

    def to_s
      "#{filename.ljust(@@max_length_name + 2)} (#{@seeders.green}/#{@leechers.red})"
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

    def set_max_length_name(length)
      @@max_length_name = length if @@max_length_name < length
    end
  end
end
