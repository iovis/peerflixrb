require 'addic7ed_downloader'
require 'highline'

module Peerflixrb
  class Commands
    attr_accessor :cli

    def initialize
      @cli = HighLine.new
      HighLine.colorize_strings
    end

    def check_requirements
      unless system('node --version > /dev/null 2>&1')
        cli.say 'Nodejs is required to make it work.'.red
        exit
      end

      unless system('peerflix --version > /dev/null 2>&1')
        cli.say 'peerflix is required. Type "npm install -g iovis9/peerflix" in your shell to install it.'.red
        exit
      end
    end

    def choose_video_and_subtitles(torrent_search, options)
      # Proactively declare them because they would be lost in the block scope
      link = nil
      sub_file = nil

      loop do
        # Choose file
        link = (options[:auto_select]) ? torrent_search.links.first : select_link(torrent_search)

        # Subtitle search
        sub_file = if options[:find_subtitles]
                     cli.say "Searching subtitles for #{link.filename.blue}".yellow
                     find_subtitles(link.filename, options)
                   elsif options[:subtitles]
                     options[:subtitles]
                   end

        # Was there a problem with the subtitle?
        if options[:find_subtitles] && sub_file.nil?
          continue = cli.agree "Could not find subtitles. Do you want to continue? #{'[y/n]'.yellow}".blue

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

    private

    def select_link(torrent_search)
      cli.say "Choose file (#{'seeders'.green}/#{'leechers'.red}):"

      cli.choose(*torrent_search.links) do |menu|
        menu.default = '1'
        menu.select_by = :index
      end
    end

    def find_subtitles(video_file, options)
      # Matches format 's06e02'? => TV Show
      if options[:search][/s\d{1,2}e\d{1,2}/i]
        find_tv_subtitles(video_file, options)
      else
        movie = Imdb.find(options[:search])
        find_movie_subtitles(movie, 'english')
      end
    end

    def find_tv_subtitles(video_file, options)
      # TV Show search based on video filename
      search = Addic7edDownloader::Search.by_filename(options[:search], lang: options[:language])
      search.extract_tags(video_file)
      return search.download_best unless options[:choose_subtitles]

      # Choose subtitle
      subtitle = cli.choose(*search.results) do |menu|
        menu.default = '1'
        menu.select_by = :index
      end

      search.download_subtitle(subtitle)
    end

    def find_movie_subtitles(movie, language)
      sub_file = YifySubtitles.download(movie.imdb_id, language)
      return sub_file unless sub_file.nil?
    end
  end
end
