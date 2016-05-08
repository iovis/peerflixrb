require 'addic7ed/search'

module Addic7ed
  module SearchFilename
    def self.search(filename, options = {})
      showname = filename[/([\w\s]+?) s\d{1,2}e\d{1,2}/i, 1].strip
      season   = filename[/s(\d{1,2})e\d{1,2}/i, 1].to_i
      episode  = filename[/s\d{1,2}e(\d{1,2})/i, 1].to_i
      options[:tags] = filename[/s\d{1,2}e\d{1,2} (.*)/i, 1].split(/[\.\s\(\)\[\]]+/)

      Search.new(showname, season, episode, options)
    end
  end
end
