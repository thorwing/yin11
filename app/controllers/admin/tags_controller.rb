class Admin::TagsController < Admin::BaseController
  def index
    @tags = CacheManager.all_tags_with_weight
  end

  def destroy
    if params[:id].present?
      tag = params[:id]
      InfoItem.all.each do |item|
        if item.tags.include? tag
          item.tags.reject!{|t| t == tag}
          item.save!
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to(admin_tags_url) }
    end
  end

end