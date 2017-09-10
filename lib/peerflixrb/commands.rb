require 'addic7ed_downloader'
require 'highline/import'

BINARY_PATH = File.join(File.dirname(__FILE__), %w(.. .. bin))

module Peerflixrb
  class Commands
    def initialize
      HighLine.colorize_strings
    end

    def check_requirements
      unless system('node --version > /dev/null 2>&1')
        say 'Nodejs is required to make it work.'.red
        exit
      end

      unless system('webtorrent --version > /dev/null 2>&1')
        say 'webtorrent is required. Type "npm install -g webtorrent-cli" in your shell to install it.'.red
        exit
      end
    end

    def webtorrent
      return "#{BINARY_PATH}/webtorrent-cli-#{os}" if os
      return 'webtorrent' if check_requirements
    end

    def choose_video_and_subtitles(torrent_search, options)
      # Proactively declare them because they would be lost in the block scope
      link = nil
      sub_file = nil

      loop do
        # Choose file
        link = options[:auto_select] ? torrent_search.links.first : select_link(torrent_search)

        # Subtitle search
        sub_file = if options[:find_subtitles]
                     say "Searching subtitles for #{link.filename.blue}".yellow
                     find_subtitles(link.filename, options)
                   elsif options[:subtitles]
                     options[:subtitles]
                   end

        # Was there a problem with the subtitle?
        if options[:find_subtitles] && sub_file.nil?
          continue = agree "Could not find subtitles. Do you want to continue? #{'[y/n]'.yellow}".blue

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
      say "Choose file (#{'seeders'.green}/#{'leechers'.red}):"

      choose(*torrent_search.links) do |menu|
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
        YifySubtitles.download(movie.imdb_id, 'english')
      end
    end

    def find_tv_subtitles(video_file, options)
      # TV Show search based on video filename
      search = Addic7edDownloader::Search.by_filename options[:search],
                                                      lang: options[:language]
      search.extract_tags(video_file)
      return search.download_best unless options[:choose_subtitles]

      # Choose subtitle
      subtitle = choose(*search.results) do |menu|
        menu.default = '1'
        menu.select_by = :index
      end

      search.download_subtitle(subtitle)
    end

    def os
      case RbConfig::CONFIG['host_os'].downcase
      when /linux/
        'linux'
      when /darwin/
        'macos'
      when /mswin|mingw/
        'win.exe'
      end
    end
  end
end
