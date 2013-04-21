#
# update
#
module Gvn
  class Command < Thor
    desc "udpate", "update from repository"
    method_option :update, :alias => 'u'
    def update
      Context.exec do |rc|
        puts "update #{rc.path}"
        system("svn update #{rc.path}")
        puts ""
      end
    end
  end
end
