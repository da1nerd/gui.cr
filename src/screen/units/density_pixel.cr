require "./screen_unit.cr"

module GUI
  # A density independant pixel
  struct DensityPixel(T) < ScreenUnit(T)
  end
end
