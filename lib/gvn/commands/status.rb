#
# status
#
module Gvn
  class Command < Thor
    desc "status", "show working status"
    def status
      store = GvnStore.new
      Context.exec do |rc|
        `svn status #{rc.path}`.each_line do |line|
          status = Status.new(line)
          next if rc.ignore?(status)
          type = store.staged?(status.path) ? '*' : ' '
          puts type + line
        end
      end
    end
  end
end
