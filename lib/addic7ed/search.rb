require 'addic7ed/subtitle'
require 'addic7ed/common'
require 'httparty'
require 'nokogiri'

# TEST
# require 'peerflixrb'
# search = Addic7ed::Search.new('game of thrones', 6, 2)
# subtitles = search.results
# su = subtitles[0]
# p su

module Addic7ed
  class Search
    BASE_URL = 'http://www.addic7ed.com'.freeze
    DEFAULTS = {
      lang: 'en',
      tags: [],
      path: './'
    }.freeze

    attr_accessor :showname, :season, :episode, :lang, :tags, :path

    def initialize(showname, season, episode, options = {})
      @showname = showname
      @season = season.to_i
      @episode = episode.to_i

      opts = DEFAULTS.merge(options)
      @lang, @tags, @path = opts.values_at(:lang, :tags, :path)
    end

    def results
      @results ||= build_subtitles_list
    end

    def download_best
      download_subtitle(results.first)
    end

    def download_subtitle(subtitle)
      # Addic7ed needs the correct Referer to be set
      response = HTTParty.get(
        BASE_URL + subtitle.url,
        headers: { 'Referer' => url, 'User-Agent' => USER_AGENTS.sample }
      )

      raise unless response.headers['content-type'].include? 'text/srt'

      filename = response.headers['content-disposition'][/filename=\"(.+?)\"/, 1]
      open(filename, 'w') { |f| f << response }
    end

    private

    def page
      @page ||= Nokogiri::HTML(HTTParty.get(url, headers: { 'User-Agent' => USER_AGENTS.sample }))
    end

    def url
      @url ||= URI.encode("#{BASE_URL}/serie/#{@showname}/#{@season}/#{@episode}/#{LANGUAGES[@lang][:id]}")
    end

    def build_subtitles_list
      # If it doesn't find the episode it redirects to the homepage
      return [] if page.at('#containernews')

      # If it doesn't find the subtitle it shows a message
      return [] if page.at(%q(font:contains("Couldn't find any subs")))

      # Create a list with results
      subtitles = page.css('div#container95m').each_with_object([]) do |subtitle, list|
        list << Addic7ed::Subtitle.new(subtitle) if subtitle.at('.NewsTitle')
      end

      # Return in number of downloads order (desc)
      subtitles.reverse!
    end
  end
end
