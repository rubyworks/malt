module Malt
  #
  module Formats
  end
end

Dir[File.dirname(__FILE__) + '/formats/*.rb'].each do |file|
  require file
end

