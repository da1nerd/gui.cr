require "./units/pixel.cr"
require "./units/density_pixel.cr"

module GUI
  # Adds some methods to numbers that allow you to more easily create a screen unit
  module NumberMixin
    struct ::Number
      # Screen pixels
      def px : GUI::Pixel
        GUI::Pixel.new(self)
      end

      # Density independant pixel
      def dp : GUI::DensityPixel
        GUI::DensityPixel.new(self)
      end
    end
  end
end
