module Malt
  #
  module Engine
  end
end

Dir[File.dirname(__FILE__) + '/engines/*.rb'].each do |file|
  require file
end

