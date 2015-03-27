# [Malt](http://rubyworks.github.io/malt)

[![Version](https://img.shields.io/gem/v/malt.svg)](https://rubygems.org/gems/malt)
[![Build Status](https://secure.travis-ci.org/rubyworks/malt.png)](http://travis-ci.org/rubyworks/malt)
[![Issues](https://img.shields.io/github/issues-raw/rubyworks/malt.svg)](https://github.com/rubyworks/malt/issues)

Malt provides a factory framework for rendering a variety of template and
markup document formats. Malt has a very object-oriented design
utilizing separate engine adapter classes and format classes. This makes
Malt easy to maintain, debug and extend, and thus more robust. In fact,
Malt supports template caching and ERB compilation by default, which was
very easy to implement thanks to it's clean design.


## Usage

### Functional API

    Malt.render(:file=>'foo.erb', :to=>:html, :data=>data)

Where `data` is a data source of some type. Malt will see
that the file is an ERB template and render it accordingly.

The output of this call will be the HTML String.

### Object-Oriented API

    Malt.file('foo.erb').to_html(data).to_s

Where +data+ is a data source of some type. Malt will see
that the file is an ERB template and render it accordingly.

To get the render text you simple need to provide the template
or markup type.

    Malt.text(text, :type=>:erb).to_html(data).to_s

Notice the `#to_s` method call. This is needed because #to_html
returns a `Malt::Format::HTML` object.


## Limitations

*JRuby* and *Rubinus* users: Not all template systems work with your Ruby.
Consequently not all of Malt will work either. Thankfully Malt only
requires template engines as they are needed, so it will work fine
in most cases. But, you will need to avoid engines that depend on compiled
code, such as `less` and `coffee-script`.


## Installation

To install with RubyGems simply open a console and type:

    $ gem install  

Usiong Bundler add to your gem file.

    gem 'malt'

For a site install you will need Ruby Setup and the compressed
packages (tar.gz or zip usually). Uncompress the package cd into
it and run setup.rb, e.g.

    $ tar -xvzf malt-x.y.z.tgz
    $ cd malt-x.y.z.tgz
    $ sudo setup.rb


## Copyrights

Copyright (c) 2010 Rubyworks

This program is ditributed under the terms of the *BSD-2-Clause* license.

See the LICENSE.txt file for details.
