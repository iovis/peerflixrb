# Peerflixrb

Wrapper for [peerflix](https://github.com/mafintosh/peerflix) with automatic search through [Kickass Torrents](kat.cr) and [Addic7ed](http://www.addic7ed.com/) (with [gem addic7ed](https://github.com/michaelbaudino/addic7ed-ruby)).

## Installation

Make sure you have **peerflix** installed:

    $ npm install -g peerflix

And then install the gem:

    $ gem install peerflixrb

## Usage

Just pass what you want to watch and it will try to fetch the file and play it through peerflix:

    $ peerflixrb suits s05e12

You can play with subtitles with ```-s``` option (Default: English).

    $ peerflixrb -s Game Of Thrones S05E01

Choose the language with ```-l LANGUAGE``` ([Available Languages](https://github.com/michaelbaudino/addic7ed-ruby/blob/master/lib/addic7ed/common.rb))

    $ peerflixrb -sl es-es Breaking Bad s05e03


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iovis9/peerflixrb.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
