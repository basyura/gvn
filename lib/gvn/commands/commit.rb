#
# commit
#
module Gvn
  class Command < Thor
    desc "commit", "commit files"
    method_option :commit, :alias => 'c'
    def commit
      store = GvnStore.new
      # staged files
      targets = store.staged_list
      # extract targets
      if targets.empty?
        Context.exec do |rc|
          `svn status #{rc.path}`.each_line do |line|
            status = Status.new(line)
            next if rc.ignore?(status) || status.noversion?
            targets << status.path
          end
        end
      end
      # no commit
      if targets.empty?
        puts "no targets"
        return
      end
      # commit
      system("svn commit #{targets.join(' ')}")
      # check status to clear stage
      targets.each do |path|
        status = Status.new(`svn status #{path}`)
        return if status.modified?
      end
      store.reset_stage
    end
  end
end
