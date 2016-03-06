require 'peerflixrb/version'
require 'nokogiri'
require 'open-uri'
require 'erb'
require 'yaml'

module Peerflixrb
  ##
  # Extract file info and magnet link from the first match of your search
  # KAT.new("Suits s05e16 1080p")
  class KAT
    attr_accessor :url, :page, :filename, :magnet

    def initialize(search)
      @url = "https://kat.cr/usearch/#{ERB::Util.url_encode(search)}/"
    end

    def page
      @page ||= Nokogiri::HTML(open(@url))
    end

    def filename
      @filename ||= CGI.unescape(params['name']) + '.' + params['extension']
    end

    def magnet
      @magnet ||= params['magnet']
    end

    private

    def params
      @params ||= YAML.load page.at_css('.iaconbox > div')['data-sc-params']
    end
  end
end
