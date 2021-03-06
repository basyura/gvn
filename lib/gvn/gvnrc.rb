
module Gvn
  class Gvnrc
    attr_accessor :path
    def initialize
      path  = File.expand_path('~/.gvnrc')
      if File.exist? path
        @yaml = YAML.load(File.open(path, &:read))
      else
        @yaml = {}
      end
    end

    def repository
      @yaml["repository"]
    end

    def all_path
      @yaml["path"] ? @yaml["path"] : '.'
    end

    def path_exists?(path)
      all_path.each do |target|
        return true if path =~ /^#{target}/
      end
      false
    end

    def ignore?(status)
      return false unless @yaml["ignore"]
      @yaml["ignore"].each do |reg|
        return true if status.path =~ /#{reg}/
      end
      return false
    end
  end
end
