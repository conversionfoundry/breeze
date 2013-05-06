module Breeze
  module Content
    class Type 
      include Mongoid::Document

      field :name, type: String

      attr_accessible :name, :content_fields_attributes

      validates :name, 
        uniqueness: true, 
        presence: true,
        format: { with: /^[\w\d\s-]*$/, 
          message: "Can contain only digits, letters, space, dashes and" +
          " underscores." }
      index({ name: 1 }, { unique: true }) # Uniqueness index

      embeds_many :content_fields,
        class_name: "Breeze::Content::Custom::Field",
        inverse_of: :content_type

      accepts_nested_attributes_for :content_fields, 
        :allow_destroy => true

      def after_create
        FileUtil.touch partial_path
      end

      def after_save
        # TODO assert consistance of the partial file 
        # if name.changed?
        #   FileUtil.mv file.was, file.name
        # end
      end

      def template_name
        name.parameterize
      end

      def partial_path
        relative_path = 'vendor/themes/template/partials/content_types'
        filename = "_#{name}.html.erb"
        Rails.root.join(relative_path, filename)
      end

      def content_fields_names
        content_fields.map(&:name)
      end

    end
  end
end
