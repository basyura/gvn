
module Gvn
  # define common methods
  class Command < Thor
  end
end

# require commands
Dir.glob(File.dirname(__FILE__) + "/commands/*.rb") do |f|
  require 'gvn/commands/' + File.basename(f).sub("\.rb", "")
end
