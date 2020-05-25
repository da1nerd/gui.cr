require "./engine"

module PrismUI
  VERSION = "0.1.0"
  # TODO: Put your code here
end

Prism::Context.run("Hello World", PrismUI::Engine.new)
