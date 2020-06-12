require "./spec_helper"

describe GUI do
  it "works" do
    Prism::Context.run("Hello World", GUI::Engine.new)
  end
end
