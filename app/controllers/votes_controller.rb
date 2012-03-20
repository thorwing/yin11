class VotesController < ApplicationController
  before_filter :pre_load
  before_filter {|c| c.require_permission(:normal_user) }

  def like
    vote(@item, 1)

    @is_fan = @item.is_fan?(current_user)
    @is_hater = @item.is_hater?(current_user)

    respond_to do |format|
      if @item.save
        format.html {redirect_to :back }
        format.xml {head :ok}
        format.js {render "votes/vote", :content_type => 'text/javascript'}
      else
        format.html { redirect_to @item }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
        format.js { head :unprocessable_entity }
      end
    end
  end

  def hate
    vote(@item, -1)
    @is_fan = @item.is_fan?(current_user)
    @is_hater = @item.is_hater?(current_user)

    respond_to do |format|
      if @item.save
        format.html {redirect_to :back }
        format.xml {head :ok}
        format.js {render "votes/vote", :content_type => 'text/javascript'}
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

  private

  def add_fan(item)
    item.fan_ids << current_user.id
    if current_user.respond_to? "liked_#{item.class.name.downcase}_ids".to_sym
      eval "current_user.liked_#{item.class.name.downcase}_ids << item.id.to_s"
    end

    item.history_fan_ids ||= []
    unless item.history_fan_ids.include? current_user.id
      RewardManager.reward_for_like(item, current_user)
      item.history_fan_ids << current_user.id
    end
  end

  def delete_fan(item)
    item.fan_ids.delete(current_user.id)
    if current_user.respond_to? "liked_#{item.class.name.downcase}_ids".to_sym
      eval "current_user.liked_#{item.class.name.downcase}_ids.delete item.id.to_s"
    end
  end

  def add_hater(item)
    item.hater_ids << current_user.id
  end

  def delete_hater(item)
    item.hater_ids.delete(current_user.id)
  end

  def vote(item, delta = 1)
    if delta > 0
      if item.is_fan?(current_user)
        delete_fan(item)
      else
        add_fan(item)
      end

      if item.is_hater?(current_user)
        delete_hater(item)
      end
    else
      if item.is_hater?(current_user)
        delete_hater(item)
      else
        add_hater(item)
      end

      if item.is_fan?(current_user)
        delete_fan(item)
      end
    end

    current_user.save
  end

  def pre_load
    @item = find_item_by_type_and_id(params[:item_type], params[:item_id])
  end
end