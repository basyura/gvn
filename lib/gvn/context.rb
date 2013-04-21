
module Gvn
  class Context
    def self.exec
      rc = Gvnrc.new
      rc.all_path.each do |path|
        rc.path = path
        yield rc
      end
    end
  end
end

