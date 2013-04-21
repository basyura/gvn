#
# status
#
module Gvn
  class Command < Thor
    desc "status", "show working status"
    def status
      root  = `svn info | grep "URL"`.sub("URL: ","").sub("file://","").chomp
      #puts Dir.pwd
      #puts root
      #if Dir.pwd == root
        store = GvnStore.new
        Context.exec do |rc|
          `svn status #{rc.path}`.each_line do |line|
            status = Status.new(line)
            next if rc.ignore?(status)
            type = store.staged?(status.path) ? '*' : ' '
            puts type + line
          end
        end
      #end
    end
  end
end
