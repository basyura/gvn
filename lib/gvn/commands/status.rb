#
# status
#
module Gvn
  class Command < Thor
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
  end
end
