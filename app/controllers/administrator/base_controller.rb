class Administrator::BaseController < ApplicationController
  before_filter() { |c| c.require_permission :editor}

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

  protected

  def get_object_based_on(type, id)
    begin
      eval("#{type}.unscoped.find(id)")
    rescue
       raise "not supported type: " + type
    end
  end

end
