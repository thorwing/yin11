#encoding utf-8
module ApplicationHelper
  def current_user_has_permission?(permission)
    if current_user.present? && current_user.has_permission?(permission)
      true
    else
      false
    end
  end

  def find_item_by_type_and_id(type, id)
    eval("#{type}.first(conditions: {id: '#{id.to_s}'})")
  end

  def truncate_content(text, length)
    text ||= ""
    text = strip_tags(text)
    if text.size > length
      #3 for dots
      text[0..length - 4] + "..."
    else
      text
    end
  end

  def render_menu(name, path)
    link_to(name, path, :class => "menu_item " + (current_page?(path) ? "selected" : "unselected" ) + " f16" )
  end

  # example: <%= link_to_add_fields( t("recipes.add"), f, :ingredients, ".steps" ) %>
  # name:  the words displayed on the add field link
  # max_len: the max num for the added item
  # divname: the position inside which to insert the item
  def link_to_add_fields(name, f, association, divname, count_range, max_len, add_class)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name,  "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"#{divname}\", \"#{count_range}\")", :class => "add_fields "+ add_class, 'data-max_len'=> max_len )

  end

  def link_to_remove_fields(name, f, removefield, showfield, html_options)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this,"+ "'"+ removefield + "',"+ "'"+ showfield + "'" +")", html_options)
  end

  def nested_comments(item, comments)
    comments.map do |comment, sub_comments|
      render("comments/single_comment", :item => item, :comment => comment) + content_tag(:div, nested_comments(item, sub_comments), :class => "nested_comments")
    end.join.html_safe
  end

  def patch_ancestry(tree)
    fake_root_nodes = []
    tree.each do |k,v|
      if k.ancestry.present?
        #not a real root node
        fake_root_nodes << {k => v}
        tree.delete(k)
      end
    end

    fake_root_nodes.each do |pair|
      parent_node = tree.find{|n| n[0].id.to_s == pair.first[0].ancestry}.first
      tree[parent_node] = pair
    end

    tree
  end

  def handle_record(record, control_list)
    if record.is_a?(Hash)
      hash = {}
      record.each do |k, v|
        values = handle_record(v, control_list)
        hash[k] = values unless values.empty?
      end
      hash
    elsif record.is_a?(String)
      record.split(' ') & control_list
    end
  end

  def ask_cache(key, expires_in, &block)
    contents = Rails.cache.fetch(key)
    if contents.nil?
      contents = block.call
      Rails.cache.write(key, contents, :expires_in => expires_in)
    end

    contents
  end

  def get_primary_tag_names(control_list = [])
    ask_cache('primary_tag_names', 3.hours) do
      records = YAML::load(File.open("app/seeds/tags.yml"))

      tag_names = {}
      records.each do |first_lv, value|
       values = handle_record(value, control_list)
       tag_names[first_lv] = values unless values.empty?
      end
      tag_names
    end
  end

  def get_primary_tags
    tags = Rails.cache.fetch('primary_tags')
    if tags.nil?
      tags = {}
      get_primary_tag_names.each do |lv, tag_names|
        if tag_names.is_a?(Array)
          tag_names.each{|t| tags[t] = Tag.find(t)}
        elsif tag_names.is_a?(Hash)
         tag_names.each do |key, value|
           value.each{|t| tags[t] = Tag.first(conditions: {name: t})}
         end
        end
      end

      Rails.cache.write('primary_tags', tags, :expires_in => 3.hours)
    end

    tags
  end

  def get_desired_tags_config
    tags = Rails.cache.fetch('top_primary_tags')
    if tags.nil?
       Logger.new(STDOUT).info "records are cached"
       tags = YAML::load(File.open("config/primary_tags.yml"))

       Rails.cache.write('top_primary_tags', tags, :expires_in => 10.minutes)
    end

    tags
  end

  def flatten_tags(nested_tags)
    flat_tag_names = []
    if nested_tags.is_a?(Array)
      flat_tag_names |= nested_tags
    elsif nested_tags.is_a?(Hash)
      nested_tags.each do |second_lv, v|
        flat_tag_names |= flatten_tags(v)
      end
    end
    flat_tag_names
  end

  def pick_hot_primary_tags(tags, tag_weight_hash, limit = 7)
    flat_tag_names = flatten_tags(tags)
    flat_tag_names.sort! {|x, y| tag_weight_hash[y].to_i <=> tag_weight_hash[x].to_i }

    left_size = flat_tag_names.size - limit
    return flat_tag_names.take(limit), left_size
  end

  def get_all_tags(of)
    ask_cache("hot_tags_of_#{of.to_s}", 1.hours) do
      tags = []
      case of
        when :recipes
          tags = Recipe.tags_with_weight
        when :albums
          tags = Album.tags_with_weight
        when :desires
          tags = Desire.tags_with_weight
      end
      tags
    end
  end

  def display_flash
    flash_types = [:error, :alert, :notice]

    messages = ((flash_types & flash.keys).collect() do |key|
      "$.jGrowl('#{flash[key]}', {header: '#{I18n.t("flash.#{key}", :default => key.to_s)}', theme: '#{key.to_s}', life: 5000});"
    end.join("\n"))

    if messages.size > 0
      content_tag(:script, :type => "text/javascript") do
        #"$(document).ready(function() {#{messages}});"
        "#{messages};"
      end
    else
      ""
    end
  end

  def load_appkey()
    sites = ["sina","qq","sohu"]
    appkeyhash = {}

    sites.each do |site|
      configs = YAML::load(File.open("config/oauth/#{site}.yml"))
      appkeyhash["#{site}_appkey"] = configs[Rails.env]["key"]
      p appkeyhash["#{site}_appkey"]
    end
    return appkeyhash
  end

  def users_browser
    user_agent =  request.env['HTTP_USER_AGENT'].downcase
    @users_browser ||= begin
    if user_agent.index('msie') && !user_agent.index('opera') && !user_agent.index('webtv')
                  'ie'+user_agent[user_agent.index('msie')+5].chr
      elsif user_agent.index('gecko/')
          'gecko'
      elsif user_agent.index('opera')
          'opera'
      elsif user_agent.index('konqueror')
          'konqueror'
      elsif user_agent.index('ipod')
          'ipod'
      elsif user_agent.index('ipad')
          'ipad'
      elsif user_agent.index('iphone')
          'iphone'
      elsif user_agent.index('chrome/')
          'chrome'
      elsif user_agent.index('applewebkit/')
          'safari'
      elsif user_agent.index('googlebot/')
          'googlebot'
      elsif user_agent.index('msnbot')
          'msnbot'
      elsif user_agent.index('yahoo! slurp')
          'yahoobot'
      #Everything thinks it's mozilla, so this goes last
      elsif user_agent.index('mozilla/')
          'gecko'
      else
          'unknown'
      end
    end

    return @users_browser
  end

  def set_mode(key, modes, new_mode, default)
    if modes.include? new_mode
      @current_mode = new_mode
    #elsif modes.include? session[key]
    #  @current_mode = session[key]
    else
      @current_mode = default
    end
    session[key] = @current_mode
  end

end
