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

    #for N:N
    def tokenize_many(*args)
      args.each do |arg|
        model_name = arg.to_s.downcase.singularize

        class_eval %(
          attr_reader :#{model_name}_tokens;
          attr_accessible :#{model_name}_tokens
        )
        define_method("#{model_name}_tokens=") { |ids|
          eval %(
          self.#{model_name}_ids = ids.split(",");

          self.#{model_name}_ids.each do |id|;
            object = #{model_name.capitalize}.find(id);
            object.#{self.class.name.downcase}_ids ||= [];
            object.#{self.class.name.downcase}_ids << self.id;
            object.save;
          end
        ) }
      end
    end

    #for 1:N
    def tokenize_one(*args)
      args.each do |arg|
        model_name = arg.to_s.downcase.singularize

        class_eval %(
          attr_reader :#{model_name}_token;
          attr_accessible :#{model_name}_token
        )
        define_method("#{model_name}_token=") { |id|
          eval %(
          self.#{model_name}_id = id;
        ) }
      end
    end
  end
end
