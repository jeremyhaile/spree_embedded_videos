var update_main_image = function(link) {
  var li = $(link).closest('li');
  if( li.is('.video') ) {
    $('#main-image').html( $(li).data('embed') );
  } else {
    $('#main-image').html('<img src="' + $(link).attr('href') + '"/>');
  }
  $('ul.thumbnails li').removeClass('selected');
  $(link).parent('li').addClass('selected');
}

var add_image_handlers = function() {
  $('ul.thumbnails li').eq(0).addClass('selected');

  $('ul.thumbnails li a')
  .click(function() {
    return false;
  })
  .bind('mouseenter',
    function() {
      update_main_image(this);
    }
  );

};
 
jQuery(document).ready(function() {
  add_image_handlers();
});
 
jQuery(document).ready(function() {
  jQuery('#product-variants input[type=radio]').click(function (event) {
    var vid = this.value;
    var text = $(this).siblings(".variant-description").html();
 
    jQuery("#variant-thumbnails").empty();
    jQuery("#variant-images span").html(text);
 
    if (images[vid].length > 0 || video_thumbnails[vid].length > 0) {
      $.each(images[vid], function(i, link) {
        jQuery("#variant-thumbnails").append('<li>' + link + '</li>');
      });

      $.each(video_thumbnails[vid], function(i, data) {
        jQuery("#variant-thumbnails").append('<li id="video_' + i + '" class="video">' + data.link + '<span>Video</span></li>');
        $('#video_' + i).data('embed', data.embed);
      });
 
      jQuery("#variant-images").show();
    } else {
      jQuery("#variant-images").hide();
    }
 
    add_image_handlers();

    var link = jQuery("#variant-thumbnails a")[0];
    if(link == null) {
      link = jQuery("#product-thumbnails a")[0];
    }
    if( link != null ) {
      update_main_image(link);
    }
  });
});
