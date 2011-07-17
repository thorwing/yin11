module ValidatorHelper
  def get_length_validator(klass, attribute)
    klass.validators_on(attribute).select{ |v| v.class == ActiveModel::Validations::LengthValidator }.first
  end

  def get_max_length(klass, attribute)
    klass = klass.class unless klass.is_a?(Class)
    validator = get_length_validator(klass, attribute)
    (validator && validator.options[:maximum].present?) ? validator.options[:maximum].to_i : GlobalConstants::GLOBAL_INPUT_MAX_LENGTH
  end

  def mark_required(klass, attribute)
    klass = klass.class unless klass.is_a?(Class)
    "*" if klass.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
  end

  def mark_required_length(klass, attribute)
    klass = klass.class unless klass.is_a?(Class)
    validator = get_length_validator(klass, attribute)
    validator ? content_tag(:span, "(" + validator.options[:message] + ")", :class => "trivial") : ""
  end
end