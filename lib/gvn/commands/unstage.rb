
module Gvn
  class Command < Thor
    desc "unstage", "unstage files"
    def unstage(file)
      require 'pstore'
      store = GvnStore.new()
      store.transaction do |store|
          list = (store["stage"] || [])
          list.delete(file)
          store["stage"] = list
      end
    end
  end
end
