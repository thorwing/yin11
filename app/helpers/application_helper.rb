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

  def get_image(image)
    logger = Logger.new(STDOUT)
    logger.info image.image.url.to_s
    if image.image?
      image_tag(image.image.url)
    end
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
    result << link_to(t("info_items.#{item.class.name.downcase}"), item.class.name.downcase.pluralize )

    if item.is_a?(Article)
      (result << t("articles.source") + ": " + item.source) if item.source.present?
      (result << item.cities[0].name) if item.cities.size > 0
      item.foods.each do |food|
        result << link_to(food.name, foods_path(:foods => food.name))
      end
    end

    result
  end
end
