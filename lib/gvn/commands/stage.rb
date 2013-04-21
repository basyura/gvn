
module Gvn
  class Command < Thor
    desc "stage", "stage files"
    def stage(file)
      require 'pstore'
      status = Status.new(`svn status #{file}`)
      store = GvnStore.new()
      store.transaction do |store|
        list = (store["stage"] || []) << status.path
        store["stage"] = list.uniq
      end
      puts "staged #{status.path}"
      puts ""
      puts "stage"
      store.transaction(true) do |store|
        store["stage"].each do |file|
          puts "  " + file
        end
      end
    end
  end
end
