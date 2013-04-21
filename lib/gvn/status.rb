
module Gvn
  class Status
    attr_reader :type, :path

    def initialize(line)
      @type, @path = line.split(" ", 2).map {|v| v.chomp}
    end

    def noversion?
      @type == '?'
    end
  end
end
