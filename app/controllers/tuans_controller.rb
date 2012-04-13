class TuansController < ApplicationController
  before_filter(:except => [:index, :show, :more, :link]) { |c| c.require_permission :editor }

  def index
    @tuans = Tuan.all.page(params[:page]).per(ITEMS_PER_PAGE_FEW)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @tuan = Tuan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def link
    @tuan = SilverHornet::TuanHornet.new.fetch_tuan(params[:tuan_url])

    respond_to do |format|
      format.js
    end
  end

end