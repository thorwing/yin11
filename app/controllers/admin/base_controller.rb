class Admin::BaseController < ApplicationController
  before_filter() { |c| c.require_permission :admin}

  def index

  end

  def get_item_based_on(type, id)
    begin
      eval("#{type}.unscoped.find(id)")
    rescue
       raise "not supported type: " + type
    end
  end

  def toggle_disabled
    item = get_item_based_on(params[:type], params[:id])
    item.disabled = !item.disabled
    item.save
    respond_to do |format|
        format.html {redirect_to item}
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
    end
  end

end
