
module Gvn
  class Command < Thor
    #
    # update
    #
    desc "udpate", "update from repository"
    method_option :update, :alias => 'u'
    def update
      Context.exec do |rc|
        puts "update #{rc.path}"
        system("svn update #{rc.path}")
        puts ""
      end
    end
    #
    # status
    #
    desc "status", "show working status"
    method_option :status, :alias => 's'
    def status
      Context.exec do |rc|
        `svn status #{rc.path}`.each_line do |line|
          status = Status.new(line)
          next if rc.ignore?(status)
          puts line
        end
      end
    end
    #
    # add
    #
    desc "add", "add files"
    method_option :add, :alias => 'a'
    def add(file)
      if file != '.'
        puts `svn add #{file}` 
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
      return if targets.empty?
      # check targets
      targets.each {|status| puts status.path }
      print "add these files? (y/n) : "
      return unless STDIN.gets.chomp == 'y'
      # add files
      targets.each do |status|
        puts `svn add #{status.path}`
      end
    end
    #
    # commit
    #
    desc "commit", "commit files"
    method_option :commit, :alias => 'c'
    def commit
      targets = []
      # extract targets
      Context.exec do |rc|
        `svn status #{rc.path}`.each_line do |line|
          status = Status.new(line)
          next if rc.ignore?(status) || status.noversion?
          targets << status.path
        end
      end
      # no commit
      if targets.empty?
        puts "no targets"
        return
      end
      # commit
      system("svn commit #{targets.join(' ')}")
    end
  end
end

