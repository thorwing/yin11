class Admin::BaseController < ApplicationController
  before_filter() { |c| c.require_permission :editor}

  def index

  end

  def toggle_disabled
    obj = get_object_based_on(params[:type], params[:id])
    obj.enabled = !obj.enabled
    obj.save
    respond_to do |format|
        format.html {redirect_to :controller => "admin/#{obj.class.name.downcase.pluralize}", :action => 'show', :id => obj.id }
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
    end
  end

  def toggle
    @item = get_object_based_on(params[:type], params[:id])
    @new_value = !@item[params[:field]]
    @item[params[:field]] = @new_value
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
