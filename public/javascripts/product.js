var update_main_image = function(link) {
  var li = $(link).closest('li');
  if( !li.is('.selected') ) {
    $('#main-image').html( li.data('content') );
    $('ul.thumbnails li').removeClass('selected');
    li.addClass('selected');
  }
}

var add_image_handlers = function() {
  $('ul.thumbnails li').eq(0).addClass('selected');

  $('ul.thumbnails li a')
  .click(function(e) {
    e.preventDefault();
  })
  .bind('mouseenter',
    function() {
      update_main_image(this);
    }
  );

  set_default_image(null);
};

var set_default_image = function(vid) {
  var link = jQuery("#variant-thumbnails-" + vid + " a")[0];
  if(link == null) {
    link = jQuery("#product-thumbnails a")[0];
  }
  if( link != null ) {
    update_main_image(link);
  }
}
 
jQuery(document).ready(function() {
  add_image_handlers();

  jQuery('#product-variants input[type=radio]').click(function () {
    var vid = this.value;
    $('.thumbnails').hide();
    $('#product-thumbnails').show();
    $('#variant-thumbnails-' + vid).show();
    set_default_image(vid);
  });
});
