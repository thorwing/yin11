#encoding utf-8
module ApplicationHelper
  def mark_required(object, attribute)
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
  end

  def mark_required_length(object, attribute)
    validators = object.class.validators_on(attribute).select{ |v| v.class == ActiveModel::Validations::LengthValidator }
    if validators.size > 0
      content_tag(:span, "(" + validators[0].options[:message] + ")", :class => "trivial")
    else
      ""
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name,  "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => "button")
  end

  #TODO
  def link_to_add_fields_with_map(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name,  "add_fields_with_map(this, \"#{association}\", \"#{escape_javascript(fields)}\")", :class => "button")
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def get_avatar(user)
    if user.profile.avatar?
      logger = Logger.new(STDOUT)
      logger.info user.profile.avatar.url.to_s
      image_tag(user.profile.avatar.url, :class => "avatar")
    else
      image_tag("default_user.png", :class => "avatar")
    end
  end

  def get_image(image, width = 100, height = 100)
    logger = Logger.new(STDOUT)
    logger.info image.image.url.to_s
    if image.image?
      image_tag(image.image.url, :width => width, :height => height, :border => 0)
    end
  end

  def get_severity_image(review, width = 24, height = 32)
     image_tag("severity_#{review.severity}_small.png", :width => width, :height => height)
  end

  def get_thumbnail(image, group = false)
    logger = Logger.new(STDOUT)
    logger.info image.image.url.to_s
    if image.image?
      link_to(image_tag(image.image.url, :border => 0, :width => 100, :height => 100, :alt => "image_thumbnail"),
              image.image.url, :title => image.caption, :rel => group ? "lightbox-group" : "lightbox" , :class => "thumbnail" )
    end
  end

  def get_cities_for_select()
    City.all.collect {|c|[ c.name, c.id ]}
  end

  def get_fields_of(class_name)
    eval( %(#{class_name}.fields.collect{|k,v| [k, k]}.reject{|a| ["_type", "_id"].include? a[0] }) )
  end

  def get_severity_of_food(food)
    reviews = Review.in_days_of(7).about(food).desc(:updated_at)

    severity_score = (reviews.size > 0) ?  reviews.inject(0){ |sum, s| sum + s.severity } / reviews.size : 0
    if severity_score < 1
      severity_level = 0
    elsif severity_score < 5
      severity_level = 1
    elsif severity_score < 10
      severity_level = 2
    else
      severity_level = 3
    end

    I18n.translate("general.severity_#{severity_level}")
  end

  def nested_comments(item, comments)
    comments.map do |comment, sub_comments|
      render("shared/comment", :item => item, :comment => comment) + content_tag(:div, nested_comments(item, sub_comments), :class => "nested_comments")
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

  def truncate_content(item, length)
    text = strip_tags(item.content)
    if length < text.size
      content_tag(:span, text[0..length] + "...")
    else
      text
    end
  end

  ### for tab control
  def tab_control(&block)
    content_tag(:div, :class => "tab_control", &block )
  end

  def tab_page (name, options= {})
    link_to_unless_current(name, options, :class => "tab_header" ) do
      content_tag(:span, name, :class => "tab_highlighted_header")
    end
  end

  def remote_tab_page (name, options={})
    link_to_unless_current(name, options, :class => "tab_header", :remote => true ) do
      content_tag(:span, name, :class => "tab_highlighted_header")
    end
  end

  def local_tab_page (name, active = false, &block)
    content = content_tag(:div, name, :class => "tab_content" , &block)
    @active_tab_content = content if active
    content_tag(:li, link_to_function(name, "show_tab_content(this, \"#{escape_javascript(content)}\")"), :class => active ? "tab_item active" :"tab_item")
  end

  def tab_content(&block)
    @active_tab_content ? @active_tab_content : content_tag(:div, :class => "tab_content", &block)
  end

  ### end for tab control

  def get_clues_of_item(item)
    result = []

    if item.is_a?(Review)
      item.foods.each do |food|
        result << link_to(food.name, foods_path(:foods => food.name))
      end
    end

    if item.is_a?(Article)
      result << link_to(t("info_items.#{item.class.name.downcase}"), item.class.name.downcase.pluralize )
      (result << t("articles.source") + ": " + item.source) if item.source.present?
      (result << item.cities[0].name) if item.cities.size > 0
      item.foods.each do |food|
        result << link_to(food.name, foods_path(:foods => food.name))
      end
    end

    result
  end

def image_uploadify
    # Putting the uploadify trigger script in the helper gives us
    # full access to the view and native rails objects without having
    # to set javascript variables.
    #
    # Uploadify is only a queue manager to hand carrierwave the files
    # one at a time. Carrierwave handles capturing, resizing and saving
    # all uploads. All limits set here (file types, size limit) are to
    # help the user pick the right files. Carrierwave is responsible
    # for enforcing the limits (white list file name, setting maximum file sizes)
    #
    # ScriptData:
    #   Sets the http headers to accept javascript plus adds
    #   the session key and authenticity token for XSS protection.
    #   The "FlashSessionCookieMiddleware" rack module deconstructs these
    #   parameters into something Rails will actually use.

    session_key_name = Rails.application.config.session_options[:key]
    %Q{

    <script type='text/javascript' charset="utf-8">
      $(document).ready(function() {
        $('#image_upload').uploadify({
          script          : '#{review_images_path(@review.id)}',
          fileDataName    : 'image[image]',
          uploader        : '/uploadify/uploadify.swf',
          cancelImg       : '/uploadify/cancel.png',
          fileDesc        : 'Images',
          fileExt         : '*.png;*.jpg;*.gif',
          sizeLimit       : #{10.megabytes},
          queueSizeLimit  : 24,
          multi           : true,
          auto            : true,
          buttonImg       : '/uploadify/upload.jpg',
          width           : 48,
          height          : 48,
          buttonText      : "",
          scriptData      : {
            '_http_accept': 'application/javascript',
            '#{session_key_name}' : encodeURIComponent('#{u(cookies[session_key_name])}'),
            'authenticity_token'  : encodeURIComponent('#{u(form_authenticity_token)}')
          },
          onComplete      : function(a, b, c, response){ eval(response) }
        });
      });
    </script>

    }.gsub(/[\n ]+/, ' ').strip.html_safe
  end



end
