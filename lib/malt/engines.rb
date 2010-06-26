module Malt
  #
  module Engines
  end
end

Dir[File.dirname(__FILE__) + '/engines/*.rb'].each do |file|
  require file
end

