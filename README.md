Spree Embedded Videos Extension
===================

This extension adds videos to the product thumbnails displayed when showing a product. It uses the oembed
protocol and ruby-oembed and currently supports YouTube, Vimeo, Hulu and Viddler. It also supports any video
service that is supported by embed.ly. (requires configuring an embed.ly API key)  It should be fairly trivial
to add additional video services if they support oembed.


Install
=======

To install just include the 'spree_embedded_videos' gem in your Gemfile and run:
```sh
rake spree_embedded_videos:install
```

Warning: This extension completely overwrites _thumbnails.html.erb and product.js from core spree, so if you have
modified these files be careful.

Configuration
=======

This extension supports Embed.ly in order to support video services that don't implement an oembed endpoint
(e.g. Brightcove).  To enable embedly support, copy config/spree_embedded_videos.yml.example file into your
Rails project's config folder.  Rename it to spree_embedded_videos.yml and configure your embedly API key.

Copyright (c) 2011 Vitrue, released under the New BSD License
