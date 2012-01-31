class VotesController < ApplicationController
  before_filter {|c| c.require_permission(:normal_user) }

  def like
    @item = find_item_by_type_and_id(params[:item_type], params[:item_id])

    if @item.fan_ids.include?(current_user.id)
      @item.votes -= 1
      @item.fan_ids.delete(current_user.id)
      if current_user.respond_to? "liked_#{@item.class.name.downcase}_ids".to_sym
        eval "current_user.liked_#{@item.class.name.downcase}_ids.delete @item.id.to_s"
        current_user.save
      end
    else
      @item.votes += 1
      @item.fan_ids << current_user.id
      if current_user.respond_to? "liked_#{@item.class.name.downcase}_ids".to_sym
        eval "current_user.liked_#{@item.class.name.downcase}_ids << @item.id.to_s"
      end

      #for older records
      if @item.history_fan_ids.blank?
        @item.history_fan_ids ||= []
      end
      unless @item.history_fan_ids.include? current_user.id
        RewardManager.reward_for_like(@item, current_user)
        @item.history_fan_ids << current_user.id
      end

      current_user.save
    end

    @is_fan = @item.fan_ids.include?(current_user.id)
    @votes = @item.votes

    respond_to do |format|
      if @item.save
        format.html {redirect_to :root }
        format.xml {head :ok}
        format.js {render :content_type => 'text/javascript'}
      else
        format.html { redirect_to @item }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
        format.js { head :unprocessable_entity }
      end
    end
  end

  #def create
  #  @item = find_item_by_type_and_id(params[:item_type], params[:item_id])
  #
  #  delta = params[:delta].to_i
  #
  #  first_vote = false
  #
  #  if delta > 0
  #    if @item.fan_ids.include?(current_user.id)
  #      delta *= -1
  #      @item.fan_ids.delete(current_user.id)
  #    elsif @item.hater_ids.include?(current_user.id)
  #      @item.hater_ids.delete(current_user.id)
  #    else
  #      @item.fan_ids << current_user.id
  #      first_vote = true
  #    end
  #  else
  #    if @item.hater_ids.include?(current_user.id)
  #      delta *= -1
  #      @item.hater_ids.delete(current_user.id)
  #    elsif @item.fan_ids.include?(current_user.id)
  #      @item.fan_ids.delete(current_user.id)
  #    else
  #      @item.hater_ids << current_user.id
  #      first_vote = true
  #    end
  #  end
  #
  #  # all people are the same
  #  weight = delta * 1 #current_user.vote_weight
  #  @item.votes += weight
  #  @votes = @item.votes
  #
  #  if first_vote
  #    if weight > 0
  #      if @item && @item.respond_to?(:author)
  #        NotificationsManager.generate!(@item.author, current_user, "like", @item )
  #      end
  #    end
  #  end
  #
  #  @is_fan = @item.fan_ids.include?(current_user.id)
  #  @is_hater = @item.hater_ids.include?(current_user.id)
  #
  #  respond_to do |format|
  #    if @item.save
  #      format.html {redirect_to :root }
  #      format.xml {head :ok}
  #      format.js {render :content_type => 'text/javascript'}
  #    else
  #      format.html { redirect_to @item }
  #      format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
  #      format.js { head :unprocessable_entity }
  #    end
  #  end
  #end
end