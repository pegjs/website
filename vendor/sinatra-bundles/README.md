sinatra-bundles
===============

An easy way to bundle CSS and Javascript assets in your sinatra application.

* Tests: [http://runcoderun.com/darkhelmet/sinatra-bundles](http://runcoderun.com/darkhelmet/sinatra-bundles)
* Documentation: [http://yardoc.org/docs/darkhelmet-sinatra-bundles](http://yardoc.org/docs/darkhelmet-sinatra-bundles)

Usage
-----

sinatra-bundles combines Javascript and CSS into one file. Meaning, you can bundle 2 or more Javascript files into one, similar with CSS stylesheets. Any bundled files are expected to be in the public directory, under 'javascripts' and 'stylesheets'

Assuming you have the following files in public:

    ./stylesheets/reset.css
    ./stylesheets/fonts.css
    ./stylesheets/grid.css
    ./javascripts/jquery.js
    ./javascripts/lightbox.js
    ./javascripts/blog.js

You can bundle these files in your app like this. First, install the gem

    % [sudo] gem install sinatra-bundles

And include it in your app:

    require 'sinatra'
    require 'sinatra/bundles'

    stylesheet_bundle(:all, %w(reset fonts grid))
    javascript_bundle(:all, %w(jquery lightbox blog))

    get '/' do
      'sinatra-bundles rocks!'
    end

That sinatra is version 0.10.1, so you'll have to grab it from source and install it that way, since it's not out yet.

Then in your view, you can use the view helpers to insert the proper script tags:

    = javascript_bundle_include_tag(:all)
    = stylesheet_bundle_link_tag(:all)

All 6 of those files will be served up in 2 files, and they'll be compressed and have headers set for caching.

Configuration
-------------

The defaults are pretty good. In development/test mode:

    bundle_cache_time # => 60 * 60 * 24 * 365, or 1 year
    compress_bundles # => false
    cache_bundles # => false
    stamp_bundles # => true

And in production mode, compression and caching are enabled

    compress_bundles # => true
    cache_bundles # => true

To change any of these, use set/enable/disable

    require 'sinatra'
    require 'sinatra/bundles'

    stylesheet_bundle(:all, %w(reset fonts grid))
    javascript_bundle(:all, %w(jquery lightbox blog))

    disable(:compress_bundles)
    enable(:cache_bundles)
    set(:bundle_cache_time, 60 * 60 * 24)
    disable(:stamp_bundles)

    get '/' do
      'sinatra-bundles rocks!'
    end

Examples
--------

Check out the code for my blog for a real example: [darkblog on github](http://github.com/darkhelmet/darkblog)

What you Need
-------------

    sinatra >= 0.10.1 (edge)
    packr
    rainpress

packr and rainpress are dependencies, but sinatra isn't, since version 0.10.1 isn't out yet, and you have to download the source manually.

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2010 Daniel Huckstep. See LICENSE for details.
