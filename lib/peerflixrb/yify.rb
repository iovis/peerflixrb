require 'httparty'
require 'zip'

module Peerflixrb
  module YifySubtitles
    API_URL  = 'http://api.yifysubtitles.com/subs/'.freeze
    BASE_URL = 'http://www.yifysubtitles.com'.freeze

    def self.download(imdb_id, language = 'english')
      url = get_subtitles_url(imdb_id, language)
      return if url.nil?

      zip = download_subtitles(url)
      extract_zip(zip)
    end

    # Helper methods (private)
    def self.get_subtitles_url(imdb_id, language)
      results = HTTParty.get(API_URL + imdb_id)

      if results['success'] && results['subtitles'] > 0
        BASE_URL + results['subs'][imdb_id][language][0]['url']
      end
    end

    def self.download_subtitles(url)
      HTTParty.get(url).body
    end

    def self.extract_zip(zip_body)
      sub_file = nil

      Zip::InputStream.open(StringIO.new(zip_body)) do |io|
        while (entry = io.get_next_entry)
          # Don't extract if not a subtitle file
          next unless entry.name =~ /\.(srt|sub|ass)\z/

          sub_file = entry.name
          open(sub_file, 'w') do |f|
            f << io.read
          end

          break # We found a subtitle file
        end
      end

      sub_file
    end
  end
end
