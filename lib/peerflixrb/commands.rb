require 'addic7ed'
require 'highline'

module Peerflixrb
  module Commands
    class << self
      attr_accessor :cli
    end

    self.cli = HighLine.new
    HighLine.colorize_strings

    def self.select_link(kat_search)
      cli.choose(*kat_search.links) do |menu|
        menu.header = 'Choose which file'.yellow
        menu.default = '1'
        menu.select_by = :index
      end
    end

    def self.choose_video_and_subtitles(kat_search, options)
      # Proactively declare them because they would be lost in the block scope
      link = nil
      sub_file = nil

      loop do
        # Choose file
        link = (options[:auto_select]) ? kat_search.links.first : select_link(kat_search)

        # Subtitle search
        sub_file = if options[:find_subtitles]
                     cli.say "Searching subtitles for #{link.filename.blue}".yellow
                     find_subtitles(link.filename, options)
                   elsif options[:subtitles]
                     options[:subtitles]
                   end

        # Was there a problem with the subtitle?
        if options[:find_subtitles] && sub_file.nil?
          continue = cli.agree "Do you want to continue? #{'[y/n]'.yellow}".green

          unless continue
            # If :auto_select, exit program
            # If video chosen, choose video again
            if options[:auto_select]
              exit
            else
              system 'clear'
              next
            end
          end
        end

        # If the loop got here then it found subtitles
        break
      end

      [link, sub_file]
    end

    # Helper methods (private)
    def self.find_subtitles(video_file, options)
      # Imdb search based on initial command input
      movie = Imdb.find(options[:search])

      if movie
        # TODO Choose language
        find_movie_subtitles(movie, 'english')
      else
        find_tv_subtitles(video_file, options[:language])
      end
    end

    def self.find_movie_subtitles(movie, language)
      sub_file = YifySubtitles.download(movie.imdb_id, language)
      return sub_file unless sub_file.nil?
      cli.say "Could not find subtitles for #{movie}".red
    end

    def self.find_tv_subtitles(video_file, language)
      # TV Show search based on video filename
      episode = Addic7ed::Episode.new(video_file)
      return File.basename episode.download_best_subtitle!(language)
    rescue Addic7ed::EpisodeNotFound
      cli.say 'Episode not found on Addic7ed'.red
    rescue Addic7ed::ShowNotFound
      cli.say 'Show not found on Addic7ed'.red
    rescue Addic7ed::NoSubtitleFound
      cli.say 'No (acceptable) subtitle has been found on Addic7ed'.red
    rescue Addic7ed::InvalidFilename
      cli.say 'Addic7ed gem could not parse the filename correctly'.red
    end
  end
end
