class CitiesController < ApplicationController
  def index
    @cities = params[:q] ? City.where(:name => /#{params[:q]}?/) : City.all

    respond_to do |format|
      format.json { render :json => @cities.map { |c| {:id => c.id, :name => c.name} } }
    end
  end

end