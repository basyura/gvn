
module Gvn
  class Command < Thor
    desc "stage", "stage files"
    def stage(file=nil)
      require 'pstore'
      # show staged files 
      return print_stage unless file
      # stage file or dir
      targets = on_stage(file)

      if targets.empty?
        puts "no target : #{file}"
        return
      end
      # print
      puts "staged files"
      targets.each {|file| puts "  " + file}
      puts ""
      puts "stage"
      print_stage
    end

    private

    def print_stage
      GvnStore.new().transaction(true) do |store|
        (store["stage"] || []).each {|file| puts "  " + file}
      end
    end

    def on_stage(file)
      # target for stage 
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
        targets = stage_directory(file)
        puts ""
      elsif File.exist?(file)
        targets << Status.new(`svn status #{file}`).path
      end
      # stage file
      store = GvnStore.new
      store.transaction do |store|
        list = (store["stage"] || []) + targets
        store["stage"] = list.uniq
      end
      targets
    end

    def stage_directory(dir)
      rc = Gvnrc.new
      dirs = [dir]
      dirs = rc.all_path if Dir.pwd =~ /#{rc.repository}$/
      targets = []
      dirs.each do |path|
        puts "stage from ... #{path}"
        `svn status #{path}`.each_line do |line|
          status = Status.new(line)
          next unless rc.path_exists?(status.path)
          next if rc.ignore?(status) || status.noversion?
          targets << status.path
        end
      end
      targets
    end
  end
end
