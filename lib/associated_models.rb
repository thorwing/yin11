module AssociatedModels
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def associate_models(*args)
      args.each do |arg|
        model_id = "#{arg.downcase}_id"

        class_eval %(
          field :#{model_id}
        )
        define_method(arg.downcase) { eval("#{arg}.find(self.#{model_id})") }
      end
    end

    def tokenize_models(*args)
      args.each do |arg|
        model_name = arg.to_s.downcase.singularize

        class_eval %(
          attr_reader :#{model_name}_tokens
        )
        define_method("#{model_name}_tokens=") { |ids|
          eval %(
          self.#{model_name}_ids = ids.split(",");

          self.#{model_name}_ids.each do |id|;
            object = #{model_name.capitalize}.find(id);
            object.article_ids ||= [];
            object.article_ids << self.id;
            object.save;
          end
        ) }
      end
    end
  end
end
