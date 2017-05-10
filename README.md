[![Gem Version](https://badge.fury.io/rb/peerflixrb.svg)](https://badge.fury.io/rb/peerflixrb) [![Build Status](https://travis-ci.org/iovis9/peerflixrb.svg?branch=master)](https://travis-ci.org/iovis9/peerflixrb) [![Dependency Status](https://gemnasium.com/badges/github.com/iovis9/peerflixrb.svg)](https://gemnasium.com/github.com/iovis9/peerflixrb)

# Peerflixrb

Wrapper for [webtorrent-cli](https://github.com/feross/webtorrent-cli) with automatic search through [Zooqle](https://zooqle.com), [YifySubtitles](http://www.yifysubtitles.com/) and [Addic7ed](http://www.addic7ed.com/).


## Installation
Install the gem:

    $ gem install peerflixrb


## Usage

Pass a string with what you want to watch and it will search Extratorrent with your query and present you with the first 5 results for you to choose. The file selected will then be sent to **webtorrent**. For **TV Shows** use the format S01E01.

    $ peerflixrb Suits s05e12
    $ peerflixrb The Godfather II

If you prefer to autoplay the first matched result, use the ```-y``` flag:

    $ peerflixrb -y Archer s07e02

You can play the video with subtitles with the ```-s``` option (Default: English). It will try and find the best match in [YifySubtitles](http://www.yifysubtitles.com/) if it's a movie, and in [Addic7ed](http://www.addic7ed.com/) if it's a TV Show.

    $ peerflixrb -s Birdman
    $ peerflixrb -s The Wire s04e05

You can choose from a list which subtitle file to use with TV Shows with the option ```-S```.

Choose the language with ```-l LANGUAGE``` ([Available Languages](https://github.com/michaelbaudino/addic7ed-ruby/blob/master/lib/addic7ed/common.rb)). Currently only for TV Shows (Choosing movie subtitles language will come soon!)

    $ peerflixrb -sl es-es Breaking Bad s05e03

If you prefer to use your own subtitles file, you can do that with the ```-t SUBTITLE_FILE``` option.

    $ peerflixrb Better Call Saul s02e04 -t subtitle_file.srt

You can autoplay in your favourite player with the corresponding option (Default: mpv).

    $ peerflixrb --mpv The Big Bang Theory s09e16

It works with DLNA too with the ```-u``` option (subtitles too!).

If you prefer to let it download without autoplaying use the option ```-n``` or ```--no-player```.


## Cache

Webtorrent takes care of cache so you can resume your downloads or watch them again.
peerflixrb will tell you where they are located so you can do as you like or leave them there till your OS takes care of it (it's stored in /tmp). When downloading with ```-n``` the output folder is the same peerflixrb was run.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iovis9/peerflixrb.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
