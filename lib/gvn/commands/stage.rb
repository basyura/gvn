
module Gvn
  class Command < Thor
    desc "stage", "stage files"
    def stage(file=nil)
      require 'pstore'

      store = GvnStore.new()
      # show staged files 
      unless file
        store.transaction(true) do |store|
          (store["stage"] || []).each {|file| puts file}
        end
        return
      end
      
      targets = []
      # stage files under directory
      if File.directory?(file)
        print "stage under #{file} ? (y/n) : "
        begin
          return if STDIN.gets.chomp != 'y'
        rescue Exception
          return
        end
        puts ""
        rc = Gvnrc.new
        `svn status #{file}`.each_line do |line|
          status = Status.new(line)
          next unless rc.path_exists?(status.path)
          next if rc.ignore?(status) || status.noversion?
          targets << status.path
        end
      elsif !File.exist?(file)
        puts 'no such fle : ' + file
        return
      else
        # stage file
        targets << Status.new(`svn status #{file}`).path
      end

      # stage file
      store.transaction do |store|
        list = (store["stage"] || []) + targets
        store["stage"] = list.uniq
      end

      puts "staged files"
      targets.each {|file| puts "  " + file}
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
