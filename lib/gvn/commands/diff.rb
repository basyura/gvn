
module Gvn
  class Command < Thor
    desc "diff", "diff files"
    def diff(file=nil)
      if file
        system("svn diff #{file}")
        return
      end
      Context.exec do |rc|
        `svn status #{rc.path}`.each_line do |line|
          status = Status.new(line)
          next if rc.ignore?(status)
          puts `svn diff #{status.path}`
        end
      end
    end
  end
end
