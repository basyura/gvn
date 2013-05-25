#
# add
#
module Gvn
  class Command < Thor
    desc "add", "add files"
    method_option :add, :alias => 'a'
    def add(file)
      if file != '.'
        puts `svn add #{file}` 
        `gvn stage --silent #{file}`
        puts `gvn status`
        return
      end
      # add targets
      targets = []
      Context.exec do |rc|
        `svn status #{rc.path}`.each_line do |line|
          status = Status.new(line)
          next if rc.ignore?(status) || !status.noversion?
          targets << status 
        end
      end
      # no targets
      if targets.empty?
        puts "no targets"
        return
      end
      # check targets
      targets.each {|status| puts status.path }
      print "\nadd these files? (y/n) : "
      begin
        return unless STDIN.gets.chomp == 'y'
      rescue Exception
        return
      end
      # add files
      targets.each do |status|
        puts `svn add #{status.path}`
        puts ''
        puts `gvn stage #{status.path}`
      end
    end
  end
end
