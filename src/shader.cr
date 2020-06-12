require "baked_file_system"
require "prism"

module GUI
  # A generic shader for the GUI
  class Shader < Prism::Shader::Program
    # uniform "guiTexture", Prism::Texture2D
    uniform "color", Prism::Maths::Vector3f
    uniform "transformationMatrix", Prism::Maths::Matrix4f

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
