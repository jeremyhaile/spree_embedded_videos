class Admin::VideosController < Admin::ResourceController
  before_filter :load_data

  create.before :set_viewable
  update.before :set_viewable
  destroy.before :destroy_before

  def update_positions
    params[:positions].each do |id, index|
      Video.update_all(['position=?', index], ['id=?', id])
    end

    respond_to do |format|
      format.js  { render :text => 'Ok' }
    end
  end

  private
  
  def location_after_save
    admin_product_videos_url(@product)
  end

  def load_data
    @product = Product.find_by_permalink(params[:product_id])
    @variants = @product.variants.collect do |variant|
      [variant.options_text, variant.id ]
    end
    @variants.insert(0, [I18n.t("all"), "All"])
  end

  def set_viewable
    if params[:video].has_key? :viewable_id
      if params[:video][:viewable_id] == "All"
        @video.viewable = @product
      else
        @video.viewable_type = 'Variant'
        @video.viewable_id = params[:video][:viewable_id]
      end
    else
      @video.viewable = @product
    end
  end

  def destroy_before
    @viewable = @video.viewable
  end

end
