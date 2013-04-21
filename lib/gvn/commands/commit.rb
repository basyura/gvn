#
# commit
#
module Gvn
  class Command < Thor
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
