# def works_with?(tag)
#
module Addic7ed
  class Subtitle
    include Comparable
    attr_accessor :version, :language, :url, :downloads, :notes

    def initialize(nokogiri_fragment)
      @version  = nokogiri_fragment.at('.NewsTitle').text[/\AVersion (.*?),/, 1]
      @language = nokogiri_fragment.at('.language').text.strip
      @complete = nokogiri_fragment.at('table tr:nth-child(3) td:nth-child(4)').text.strip
      @url = generate_download_url(nokogiri_fragment)
      @notes = nokogiri_fragment.at('.newsDate').text.strip
      @hi = nokogiri_fragment.css('.newsDate').last.children[1]['title'] == 'Hearing Impaired'
      @downloads = nokogiri_fragment.css('.newsDate').last.text[/(\d+) Downloads/, 1].to_i
    end

    def to_s
      str = "#{@version} (#{@language}): #{@complete} [#{@downloads} Downloads]"
      str << "— #{@notes}" unless @notes.empty?
    end

    # We can sort by downloads number
    def <=>(other)
      @downloads <=> other.downloads
    end

    def completed?
      # 'Completed' or '33.37% Completed'
      @complete == 'Completed'
    end

    def hearing_impaired?
      @hi
    end

    def works_with?(tag)
      @notes[/works? with \"?([^\"\s]+)/i, 1].downcase.include? tag.downcase
    end

    private

    def generate_download_url(nokogiri_fragment)
      links = nokogiri_fragment.css('.buttonDownload')

      case links.length
      when 1
        links[0]['href']
      # If there are two download buttons, the second is the "most updated"
      when 2
        links[1]['href']
      end
    end
  end
end
