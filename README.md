Spree Embedded Videos Extension
===================

This extension adds videos to the product thumbnails displayed when showing a product.  It uses
the oembed protocol and ruby-oembed and currently supports YouTube, Vimeo, Hulu and Viddler.  It should
be fairly trivial to add additional video services if they support oembed.


Install
=======

To install just include the 'spree-embedded-videos' gem in your Gemfile and run:
```sh
rake spree_embedded_videos:install
```

Warning: This extension completely overwrites _thumbnails.html.erb and product.js from core spree, so if you have
modified these files be careful.


Copyright (c) 2011 Vitrue, released under the New BSD License
