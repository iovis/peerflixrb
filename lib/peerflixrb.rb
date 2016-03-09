require 'addic7ed'
require 'cgi'
require 'erb'
require 'nokogiri'
require 'open-uri'
require 'peerflixrb/version'
require 'yaml'

module Peerflixrb
  def self.find_subtitles(video_file, language)
    episode = Addic7ed::Episode.new(video_file)
    return File.basename episode.download_best_subtitle!(language)
  rescue Addic7ed::EpisodeNotFound
    puts "Episode not found on Addic7ed : #{episode.video_file.filename}."
  rescue Addic7ed::ShowNotFound
    puts "Show not found on Addic7ed : #{episode.video_file.filename}."
  rescue Addic7ed::NoSubtitleFound
    puts "No (acceptable) subtitle has been found on Addic7ed for #{episode.video_file.filename}."
  rescue Addic7ed::InvalidFilename
    puts "Addic7ed gem doesn't like the format passed. Skipping subtitles."
  end

  ##
  # Extract file info and magnet link from the first match of your search
  # KAT.new("Suits s05e16 1080p")
  class KAT
    attr_accessor :url

    def initialize(search)
      @url = "https://kat.cr/usearch/#{ERB::Util.url_encode(search)}/"
    end

    def page
      @page ||= Nokogiri::HTML(open(@url))
    end

    def filename
      @filename ||= "#{CGI.unescape(params['name'])}.#{params['extension']}"
    end

    def magnet
      @magnet ||= params['magnet']
    end

    def info_hash
      @info_hash ||= extract_hash
    end

    private

    def params
      @params ||= YAML.load page.at_css('.iaconbox > div')['data-sc-params']
    end

    def extract_hash
      # Extract magnet properties to a Hash
      magnet_params = CGI.parse(URI.parse(magnet).query)
      magnet_params['xt'].first.match(/[0-9A-F]+/).to_s.downcase
    end
  end
end
