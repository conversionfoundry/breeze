CarrierWave.configure do |config| 
  config.cache_dir = Rails.root.join("tmp/uploads")
end

#module CarrierWave
  #module ConditionalVersions
    #extend ActiveSupport::Concern

    #included do
      #extend ClassMethods
    #end
    
    #module ClassMethods
      #def version_conditions
        #@version_conditions ||= {}
      #end

      #def version(name, options = {}, &block)
        #name = name.to_sym
        #version_conditions[name] = options
        #versions[name] = Class.new(self)
        #versions[name].version_names.push(*version_names)
        #versions[name].version_names.push(name)
        #class_eval <<-RUBY
          #def #{name}
            #versions[:#{name}]
          #end
        #RUBY
        #versions[name].class_eval(&block) if block
        #versions[name]
      #end
    #end

    #def version_conditions
      #@version_conditions ||= self.class.version_conditions.dup
    #end

    #def store_versions!(new_file)
      #versions.each do |name, v| 
        #v.store!(new_file) if satisfies_version_requirements?(name, new_file)
      #end
    #end

    #def retrieve_versions_from_cache!(cache_name)
      #versions.each do |name, v| 
        #v.retrieve_from_cache!(cache_name) if satisfies_version_requirements?(name)
      #end
    #end

    #def retrieve_versions_from_store!(identifier)
      #versions.each do |name, v| 
        #v.retrieve_from_store!(identifier) if satisfies_version_requirements?(name)
      #end
    #end

    #def satisfies_version_requirements?(name, new_file = nil, remove = true)
      #file_to_check = new_file.nil? ? file : new_file
      #if version_conditions[name] && version_conditions[name][:if]
        #(send(version_conditions[name][:if], file_to_check)).tap do |met|
          #versions.delete(name) if remove && !met
        #end
      #else
        #true
      #end
    #end
  #end
#end
