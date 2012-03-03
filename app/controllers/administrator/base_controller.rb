class Administrator::BaseController < ApplicationController
  before_filter() { |c| c.require_permission :administrator}

  def index

  end

  def toggle
    @item = get_object_based_on(params[:type], params[:id])
    @field = params[:field]
    @new_value = !@item[@field]
    @item[@field] = @new_value
    @item.save!
    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  def tune
    @item = get_object_based_on(params[:type], params[:id])
    if @item.respond_to? :priority
      delta = params[:delta].to_i
      @item.priority += delta
      @item.priority = [@item.priority, MIN_PRIORITY].max
      @item.priority = [@item.priority, MAX_PRIORITY].min
      @new_priority = @item.priority
      @item.save
    end

    respond_to do |format|
        format.js {render :content_type => 'text/javascript'}
    end
  end

  protected

  def get_object_based_on(type, id)
    begin
      eval("#{type}.unscoped.find(id)")
    rescue
      #raise "not supported type: " + type
      nil
    end
  end

end
