class SpreeEmbeddedVideosHooks < Spree::ThemeSupport::HookListener
  insert_after :admin_product_tabs, 'admin/videos/menu_item'
end