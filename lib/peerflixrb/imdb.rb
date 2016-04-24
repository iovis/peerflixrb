require 'httparty'
require 'json'

module Peerflixrb
  module Imdb
    def self.find(title)
      params = { 'json' => '1', 'nr' => 1, 'tt' => 'on', 'q' => title }
      query = HTTParty.get('http://www.imdb.com/xml/find', query: params)
      results = JSON.load(query)['title_popular']

      # Return the most popular for that search
      Movie.new(results.first) if results
    end

    class Movie
      attr_accessor :imdb_id, :title, :year

      def initialize(params)
        @imdb_id = params['id']
        @title = params['title']
        @year = params['description'].match(/\A\d+/).to_s
      end

      def to_s
        "#{title} (#{year})"
      end
    end
  end
end