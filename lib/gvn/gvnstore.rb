
module Gvn
  class GvnStore
    def initialize
      require 'pstore'
      @store = PStore.new(File.expand_path('~/.gvn/gvn.store'))
    end

    def transaction(read_only = false)
      @store.transaction(read_only) {|store| yield store }
    end

    def staged?(file)
      @store.transaction(true) do |store|
        list = store["stage"] || []
        return list.include?(file)
      end
    end

    def staged_list
      @store.transaction(true) {|store| return store["stage"] || [] } 
    end

    def reset_stage
      @store.transaction {|store| store["stage"] = [] }
    end
  end
end
