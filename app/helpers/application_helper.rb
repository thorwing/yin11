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
    eval("#{type}.find('#{id.to_s}')")
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
    link_to(name, path, :class => (current_page?(path) ? "selected" : "unselected" ) + " f16" )
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

  def get_hot_tags(limit = ITEMS_PER_PAGE_FEW, of = :feeds)
    key = "hot_tags_of_#{of.to_s}"
    tags = Rails.cache.fetch(key)
    unless tags
      case of
        when :feeds
          tags = Tag.desc(:feeds).limit(100)
        when :recipes
          tags = Recipe.tags_with_weight.take(100)
        else
          tags = []
      end
      Rails.cache.write(key, tags, :expires_in => 1.hours)
    end

    #take some of the cached tags, 100 is too many
    tags.take(limit)
  end

  def get_records
    records = Rails.cache.fetch('records')
    if records.nil?
       Logger.new(STDOUT).info "records are cached"
       records = YAML::load(File.open("app/seeds/tags.yml"))
       Rails.cache.write('records', records, :expires_in => 3.hours)
    end
  end


  def display_flash
    flash_types = [:error, :alert, :notice]

    messages = ((flash_types & flash.keys).collect() do |key|
      "$.jGrowl('#{flash[key]}', {header: '#{I18n.t("flash.#{key}", :default => key.to_s)}', theme: '#{key.to_s}'});"
    end.join("\n"))

    if messages.size > 0
      content_tag(:script, :type => "text/javascript") do
        "$(document).ready(function() {#{messages}});"
      end
    else
      ""
    end
  end

end
