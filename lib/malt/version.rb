module Malt

  # Access to project metadata.
  def self.metadata
    @metadata ||= (
      require 'yaml'
      YAML.load(File.new(File.dirname(__FILE__) + '/../malt.yml'))
    )
  end

  # Access to project metadata via constants.
  def self.const_missing(name)
    key = name.to_s.downcase
    metadata[key] || super(name)
  end

  # TODO: Here until bug in 1.8 is fixed.
  VERSION = metadata['version']

end

