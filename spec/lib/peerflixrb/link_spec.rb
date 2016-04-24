require 'spec_helper'

describe Peerflixrb::Link do
  subject { build :link }
  let(:filename) { 'Suits S05E16 HDTV x264-KILLERS[ettv].mp4' }
  let(:magnet) { 'magnet:?xt=urn:btih:F0686728B98BBFF1B07AFCAC73620E2FBC200F4B&dn=suits+s05e16+hdtv+x264+killers+ettv&tr=udp%3A%2F%2Ftracker.publicbt.com%2Fannounce&tr=udp%3A%2F%2Fglotorrents.pw%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A80%2Fannounce' }
  let(:info_hash) { 'f0686728b98bbff1b07afcac73620e2fbc200f4b' }

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
