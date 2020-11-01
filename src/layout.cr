require "yaml"

module GUI
  class Layout
    property yaml

    def initialize(file : String)
      @yaml = YAML.parse(File.read(file))
    end
  end
end
