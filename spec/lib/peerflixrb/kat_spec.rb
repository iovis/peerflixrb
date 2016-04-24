require 'spec_helper'

describe Peerflixrb::KAT do
  subject { build :kat }
  let(:url) { 'https://kat.cr/usearch/suits%20s05e16/' }

  before(:each) do
    stub_request(:get, url).to_return File.new('spec/http_stubs/kat_successful_search.http')
  end

  it 'generates the search url' do
    expect(subject.url).to eq url
  end

  context '#results_found' do
    it 'is true if results are found' do
      expect(subject.results_found).to be true
    end

    it 'is false if no results are found' do
      stub_request(:get, url).to_return File.new('spec/http_stubs/kat_failed_search.http')
      expect(subject.results_found).to be false
    end
  end

  context '#links' do
    it "generates #{Peerflixrb::KAT::NUMBER_OF_LINKS} links" do
      expect(subject.links.size).to eq Peerflixrb::KAT::NUMBER_OF_LINKS
    end

    it 'generates Link instances' do
      link = subject.links.first
      expect(link).to be_a(Peerflixrb::Link)
    end
  end
end
