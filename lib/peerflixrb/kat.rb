require 'erb'
require 'nokogiri'
require 'yaml'

module Peerflixrb
  ##
  # Extract a list of results from your search
  # KAT.new("Suits s05e16 1080p")
  class KAT
    NUMBER_OF_LINKS = 5

    attr_accessor :url

    def initialize(search)
      @url = "https://kat.cr/usearch/#{ERB::Util.url_encode(search)}/"
    end

    def page
      @page ||= Nokogiri::HTML(open(@url))
    end

    def results_found
      @results_found ||= page.at('p:contains("did not match any documents")').nil?
    rescue OpenURI::HTTPError
      @results_found = false
    end

    def links
      @links ||= generate_links
    end

    private

    def generate_links
      links = []
      crawled_links = page.css('.iaconbox > div')
      seeders = page.css('td.green')
      leechers = page.css('td.red')

      crawled_links[0..NUMBER_OF_LINKS - 1].each_with_index do |link, i|
        params = YAML.load(link['data-sc-params'])
        params['seeders'] = seeders[i].text
        params['leechers'] = leechers[i].text
        links << Link.new(params)
      end

      return links
    end
  end
end
