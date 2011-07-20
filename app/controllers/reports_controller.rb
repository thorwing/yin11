class ReportsController < ApplicationController
  def new
      vendor = Vendor.find(params[:vendor_id])
      @report = vendor.reports.build
      @report.email = current_user.email if current_user
      respond_to do |format|
        if params[:popup]
          format.html {render "new", :layout => "dialog" }
        else
          format.html # new.html.erb
        end
      end
  end

  def create
    @report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        format.html {redirect_to @report}
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
        format.js {render :content_type => 'text/javascript'}
      end
    end
  end
end