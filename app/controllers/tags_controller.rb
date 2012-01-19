class TagsController < ApplicationController
  before_filter(:only => [:destroy]) { |c| c.require_permission :editor }

  def query
    query_str = params[:q]
    if query_str.present?
      # not case sensitive
      @tags = Tag.where(name: /#{query_str}/i).to_a #CacheManager.all_tags_with_weight.select {|t| t[0] =~ /#{query}?/}
    else
      @tags = Tag.all.to_a
    end

    #truncate the tag name
    new_tag_name = query_str[0..(MAX_TAG_CHARS - 1)]
    is_new_tag = @tags.select{|t| t.name.include?(new_tag_name)}.empty?
    #new_tag = Tag.create(:name => new_tag_name) if is_new_tag

    #TODO to_s
    @tags =  @tags.map { |t| {:id => t.name, :name => t.name} }

    #insert new tag
    @tags.insert(0, {:id => new_tag_name, :name => "#{new_tag_name} (#{t("tags.new_tag")})" }) if is_new_tag

    respond_to do |format|
      format.json { render :json => @tags }
    end
  end

  def destroy
    if params[:id].present?
      @tag = Tag.find(params[:id])
      @tag.destroy
      tag = params[:id]
      #TODO
      #InfoItem.all.each do |item|
      #  if item.tags.include? tag
      #    item.tags.reject!{|t| t == tag}
      #    item.save!
      #  end
      #end
    end

    respond_to do |format|
      format.html { redirect_to(administrator_tags_url) }
    end
  end

end