module ValidatorHelper
  def get_length_validator(klass, attribute)
    klass.validators_on(attribute).select{ |v| v.class == ActiveModel::Validations::LengthValidator }.first
  end

  def get_max_length(klass, attribute)
    klass = klass.class unless klass.is_a?(Class)
    validator = get_length_validator(klass, attribute)
    (validator && validator.options[:maximum].present?) ? validator.options[:maximum].to_i : GLOBAL_INPUT_MAX_LENGTH
  end

  def mark_required(klass, attribute)
    klass = klass.class unless klass.is_a?(Class)
    "*" if klass.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
  end

  def mark_required_length(klass, attribute)
    klass = klass.class unless klass.is_a?(Class)
    validator = get_length_validator(klass, attribute)
    if validator
      msg = ""
      if validator.options[:minimum].present? && validator.options[:maximum].present?
        msg = I18n.t("validations.general.length_msg", :min => validator.options[:minimum], :max => validator.options[:maximum])
      elsif validator.options[:minimum].present?
        msg = I18n.t("validations.general.min_length_msg", :min => validator.options[:minimum])
      elsif validator.options[:maximum].present?
        msg = I18n.t("validations.general.max_length_msg", :max => validator.options[:maximum])
      end
      ( msg = "(" + msg + ")" ) if msg.present?
      content_tag(:span, msg, :class => "trivial")
    else
      ""
    end
  end
end