class MercuryAuthController < ApplicationController
  before_filter(:only => [:edit]) { |c| c.require_permission :editor }

  def edit
    render :text => '', :layout => 'mercury'
  end

end

