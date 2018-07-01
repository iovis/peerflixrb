require 'addic7ed_downloader'
require 'highline/import'

BINARY_PATH = File.join(File.dirname(__FILE__), %w(.. .. bin))

module Peerflixrb
  class Commands
    def initialize
      HighLine.colorize_strings
    end

    def check_requirements
      unless node_installed?
        say 'Nodejs is required to make it work.'.red
        exit
      end

      unless webtorrent_installed?
        say 'webtorrent is required. Type "npm install -g webtorrent-cli" in your shell to install it.'.red
        exit
      end
    end

    def webtorrent
      return 'webtorrent' if webtorrent_installed?
      return "#{BINARY_PATH}/webtorrent-cli-#{os}" if os
      check_requirements
    end

    def node_installed?
      system('node --version > /dev/null 2>&1')
    end

    def webtorrent_installed?
      system('webtorrent --version > /dev/null 2>&1')
    end

    def choose_video_and_subtitles(search_result, options)
      # Proactively declare them because they would be lost in the block scope
      link     = nil
      links    = search_result.links.sort.reverse
      sub_file = nil

      loop do
        # Choose file
        link = options[:auto_select] ? links.first : select_link(links)

        # Subtitle search
        sub_file = if options[:find_subtitles]
                     # TODO
                     say "Searching subtitles for #{link.title.blue}".yellow
                     find_subtitles(link, options)
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

    def select_link(links)
      say "Choose file (#{'seeders'.green}/#{'leechers'.red}):"
      choose(*links) do |menu|
        menu.default = '1'
        menu.select_by = :index
      end
    end

    def find_subtitles(link, options)
      case options[:kind]
      when :movie
        YifySubtitles.download(link.imdb_id, 'english')
      when :show
        filename = link.filename || link.title

        # Try to download by filename
        if link.filename
          search = Addic7edDownloader::Search.by_filename(link.filename, lang: options[:language])

          unless options[:choose_subtitles]
            return search.download_best if search.download_best
          end
        end

        # Try to download by title (Archer has problems with this because it usually
        # appears as "Archer 2009 - 02x03", which gives Addic7ed API problems)
        if search.nil? || search.results.empty?
          search = Addic7edDownloader::Search.by_filename(link.title, lang: options[:language])
          search.extract_tags(link.filename) if link.filename

          unless options[:choose_subtitles]
            return search.download_best if search.download_best
          end
        end

        # Choose subtitle
        say "Choose subtitles for #{filename.blue}:".yellow
        subtitle = choose(*search.results) do |menu|
          menu.default = '1'
          menu.select_by = :index
        end

        search.download_subtitle(subtitle)
      end
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
