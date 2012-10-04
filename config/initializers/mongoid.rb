# encoding: utf-8

require "mongoid/validations"

# TODO: This validator is broken (always fails for Breeze Commerce classes). It's probably also redundant, as Mongoid now has validates_uniqueness built in.
module Mongoid #:nodoc:
  module Validations #:nodoc:
    # Validates whether or not a field is unique against the documents in the
    # database.
    #
    # Example:
    #
    #   class Person
    #     include Mongoid::Document
    #     field :title
    #
    #     validates_uniqueness_of :title
    #   end
    # class UniquenessValidator < ActiveModel::EachValidator
    #   def validate_each(document, attribute, value)
    #     conditions = { attribute => value, :_id => { '$ne' => document.id } }
        
    #     Array.wrap(options[:scope]).each do |item|
    #       conditions[item] = document.attributes[item]
    #     end
    #     # binding.pry
    #     return if document.collection.where(conditions).nil?
        
    #     # if document.new_record? || key_changed?(document)
    #       document.errors.add(attribute, :taken, :default => options[:message], :value => value)
    #     # end
    #   end

    # protected
    #   def key_changed?(document)
    #     (document.primary_key || {}).each do |key|
    #       return true if document.send("#{key}_changed?")
    #     end; false
    #   end
    # end
  end
end
