#encoding utf-8
module ApplicationHelper
  def is_user_self(user)
    current_user && current_user.id == user.id
  end

  def current_user_has_permission?(permission)
    if current_user.present? && current_user.has_permission?(permission)
      true
    else
      false
    end
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

  #<%= link_to_add_fields( t("recipes.add"), f, :ingredients, ".steps" ) %>
  def link_to_add_fields(name, f, association, divname, max_len)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name,  "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\", \"#{divname}\")", :class => "button add_fields", 'data-max_len'=> max_len)

  end

  def link_to_remove_fields(name, f, removefield, showfield)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this,"+ "'"+ removefield + "',"+ "'"+ showfield + "'" +")")
  end

  def get_provinces_for_select(drop_first = true)
    provinces = Province.only(:name, :code).asc(:code).collect {|c|[ c.name, c.id ]}
    drop_first ? provinces.reject{|p| p[1] == "ALL"} : provinces
  end

  def get_cities_of_provinces(province)
    province.cities.collect {|c|[ c.name, c.id ]}
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

  def get_hot_tags(limit = ITEMS_PER_PAGE_FEW)
    #TODO cache it
    Tag.desc(:feeds).limit(limit)
  end

  def get_icon_of(obj)
    image_tag("#{obj.class.name.downcase}_icon.png")
  end

  def get_clues_of_item(item)
    result = []
    result << link_to(t("info_items.#{item.class.name.downcase}"), "/" + item.class.name.downcase.pluralize)

    if item.is_a?(Article)
      (result << item.source.name) if item.source

      if item.region_ids.present?
        item.region_ids.each do |region_id|
          city = City.first(:conditions => {:id => region_id})
          if city
            result << city.name
          else
            province = Province.first(:conditions => {:id => region_id})
            result << province.name
          end
        end
      end
    end

     result.map{|r| content_tag(:small, r)}.join("|").html_safe
  end

  def tag_cloud( tags )
     classes = %w(cloud1 cloud2 cloud3 cloud4 cloud5 cloud6 cloud7)

     max, min = 0, 0
     tags.each { |t|
       max = t[1].to_i if t[1].to_i > max
       min = t[1].to_i if t[1].to_i < min
     }

     divisor = ((max - min) / classes.size) + 1

     tags.each { |t|
        yield t[0], classes[(t[1].to_i - min) / divisor]
     }
   end

  #for plugins

  #def image_uploadify
  #  # Putting the uploadify trigger script in the helper gives us
  #  # full access to the view and native rails objects without having
  #  # to set javascript variables.
  #  #
  #  # Uploadify is only a queue manager to hand carrierwave the files
  #  # one at a time. Carrierwave handles capturing, resizing and saving
  #  # all uploads. All limits set here (file types, size limit) are to
  #  # help the user pick the right files. Carrierwave is responsible
  #  # for enforcing the limits (white list file name, setting maximum file sizes)
  #  #
  #  # ScriptData:
  #  #   Sets the http headers to accept javascript plus adds
  #  #   the session key and authenticity token for XSS protection.
  #  #   The "FlashSessionCookieMiddleware" rack module deconstructs these
  #  #   parameters into something Rails will actually use.
  #
  #  session_key_name = Rails.application.config.session_options[:key]
  #  %Q{
  #  <script type='text/javascript' charset="utf-8">
  #    $(document).ready(function() {
  #      $('#image_uploader').uploadify({
  #        script          : '#{images_path}',
  #        fileDataName    : 'image[picture]',
  #        uploader        : '/uploadify/uploadify.swf',
  #        cancelImg       : '/uploadify/cancel.png',
  #        fileDesc        : 'Images',
  #        fileExt         : '*.png;*.jpg;*.gif',
  #        sizeLimit       : #{2.megabytes},
  #        queueSizeLimit  : 24,
  #        multi           : true,
  #        auto            : true,
  #        buttonImg       : '/uploadify/upload.gif',
  #        width           : 32,
  #        height          : 32,
  #        buttonText      : "",
  #        scriptData      : {
  #          '_http_accept': 'application/javascript',
  #          '#{session_key_name}' : encodeURIComponent('#{u(cookies[session_key_name])}'),
  #          'authenticity_token'  : encodeURIComponent('#{u(form_authenticity_token)}')
  #        },
  #        onComplete      : function(a, b, c, response){ eval(response) }
  #      });
  #    });
  #  </script>
  #
  #  }.gsub(/[\n ]+/, ' ').strip.html_safe
  #end

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
