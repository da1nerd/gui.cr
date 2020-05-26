require "baked_file_system"
require "prism"

module PrismUI
  # A generic shader for the GUI
  class UIShader < Prism::Shader::Program
    uniform "guiTexture", Prism::Texture2D
    uniform "transformationMatrix", Matrix4f

    def initialize
      initialize "ui" do |path|
        ShaderStorage.get(path).gets_to_end
      end
    end

    private class ShaderStorage
      extend BakedFileSystem

      bake_folder "./glsl"
    end
  end
end
