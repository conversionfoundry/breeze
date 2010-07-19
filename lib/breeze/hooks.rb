module Breeze
  module Hooks
    def hook(hook_name, &block)
      @_hooks ||= {}
      returning(@_hooks[hook_name.to_sym] ||= []) do |hooks|
        hooks << block
      end
    end
    
    def run_hook(hook_name, initial_value, *args)
      @_hooks ||= {}
      (@_hooks[hook_name.to_sym] || []).inject(initial_value) do |value, hook|
        hook.call value, *args
      end
    end
  end
end
