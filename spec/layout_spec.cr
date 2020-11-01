require "./spec_helper"
require "../src/layout.cr"

describe GUI::Layout do
  {% if !flag?(:ci) %}
    it "renders a layout file" do
      # layout = GUI::Layout.new("./spec/layout.yml")
      # TODO: support some more configuration within layouts
    end
  {% end %}
end
