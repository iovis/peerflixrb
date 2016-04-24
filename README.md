[![Build Status](https://travis-ci.org/iovis9/peerflixrb.svg?branch=master)](https://travis-ci.org/iovis9/peerflixrb) [![Gem Version](https://badge.fury.io/rb/peerflixrb.svg)](https://badge.fury.io/rb/peerflixrb)

# Peerflixrb

Wrapper for [peerflix](https://github.com/mafintosh/peerflix) with automatic search through [Kickass Torrents](kat.cr) and [Addic7ed](http://www.addic7ed.com/) (with [gem addic7ed](https://github.com/michaelbaudino/addic7ed-ruby)).


## Requirements

Make sure you have **peerflix** installed:

    $ npm install -g peerflix


## Installation
Install the gem:

    $ gem install peerflixrb


## Usage

Pass a string with what you want to watch and it will search KAT with your query and present you with the first 5 results for you to choose. The file selected will then be sent to **peerflix**.

    $ peerflixrb Suits s05e12

If you prefer to autoplay the first matched result, use the ```-y``` flag:

    $ peerflixrb -y Archer s07e02

You can play the video with subtitles with the ```-s``` option (Default: English). It will try and find the best match in [Addic7ed](http://www.addic7ed.com/).

    $ peerflixrb -s Game Of Thrones S05E01 1080p

Choose the language with ```-l LANGUAGE``` ([Available Languages](https://github.com/michaelbaudino/addic7ed-ruby/blob/master/lib/addic7ed/common.rb))

    $ peerflixrb -sl es-es Breaking Bad s05e03

If you prefer to use your own subtitles file, you can do that with the ```-t SUBTITLE_FILE``` option.

    $ peerflixrb Better Call Saul s02e04 -t subtitle_file.srt

You can autoplay in VLC or MPlayer with the corresponding option (Default: VLC).

    $ peerflixrb --mplayer The Big Bang Theory s09e16 HDTV

Or you can just let it download without autoplaying with ```-n``` or ```--no-player```.


## Cache

The original peerflix takes care of cache so you can resume your downloads or watch them again.
peerflixrb will tell you where they are located so you can do as you like or leave them there till your OS takes care of it (it's stored in /tmp).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iovis9/peerflixrb.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
