# frozen_string_literal: true

require_relative "color_hash/version"
require_relative "color_hash/generator"

# Generate a color in HSL space from a given String
module ColorHash
  class ArgumentError < StandardError; end

  # Creates a new instance of a ColorHash Generator
  #
  # Hue values shall range between [0..360] degrees and are given
  # as a Hash of the format {min: hue_min, max: hue_max}.
  # If you provide multiple hue ranges passed in an Array,
  # the given String will be binned to one of the hue ranges
  # based on the calculated hash.
  #
  # Lightness is described as a floating number between 0.0 and 1.0.
  # If you provide multiple lightness values passed in an Array,
  # the given String will be binned to one of the lightness values
  # based on the calculated hash.
  #
  # Saturation is described as a floating number between 0.0 and 1.0
  # If you provide multiple saturation values passed in an Array,
  # the given String will be binned to one of the saturation values
  # based on the calculated hash.
  #
  # The Hash function can be either :bkdr (default) or :sha256
  def self.new(hue: [{ min: 0, max: 360 }], lightness: [0.35, 0.5, 0.65], saturation: [0.35, 0.5, 0.65], hash: :bkdr)
    ColorHash::Generator.new(hue: hue, lightness: lightness, saturation: saturation, hash: hash)
  end
end
