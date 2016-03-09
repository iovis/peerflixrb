require 'spec_helper'

describe Peerflixrb::KAT do
  subject { build :kat }
  let(:url) { 'https://kat.cr/usearch/suits%20s05e16/' }
  let(:filename) { 'Suits S05E16 HDTV x264-KILLERS[ettv].mp4' }
  let(:magnet) { 'magnet:?xt=urn:btih:F0686728B98BBFF1B07AFCAC73620E2FBC200F4B&dn=suits+s05e16+hdtv+x264+killers+ettv&tr=udp%3A%2F%2Ftracker.publicbt.com%2Fannounce&tr=udp%3A%2F%2Fglotorrents.pw%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce' }
  let(:info_hash) { 'F0686728B98BBFF1B07AFCAC73620E2FBC200F4B' }

  before(:each) do
    stub_request(:get, url).to_return File.new('spec/http_stubs/suits_05_16.http')
  end

  it 'generates the search url' do
    expect(subject.url).to eq url
  end

  it 'finds the correct magnet link' do
    expect(subject.magnet).to eq magnet
  end

  it 'generates the info hash' do
    expect(subject.info_hash).to eq info_hash
  end

  it 'generates the proper video name' do
    expect(subject.filename).to eq filename
  end
end
