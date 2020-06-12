require "./spec_helper"

describe GUI do
  {% if !flag?(:ci) %}
    it "works" do
      Prism::Context.run("Hello World", GUI::Engine.new)
    end
  {% end %}
end
