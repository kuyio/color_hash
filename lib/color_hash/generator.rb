# frozen_string_literal: true

module ColorHash
  # A ColorHash::Generator can be used to calculate the color value for a given String.
  # You can specify the desired hue, lightness and saturation (HSL) ranges
  # for the resulting color value, as well as the hash algorithm to be used
  # for converting Strings to the numbered color space.
  #
  # Ruby implementation of https://github.com/zenozeng/color-hash
  class Generator
    # Creates a new ColorHash instance described by the given hue, saturation
    # and lightness ranges, as well as a Hash function.
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

    def initialize(
      hue: [{ min: 0, max: 360 }],
      lightness: [0.35, 0.5, 0.65],
      saturation: [0.35, 0.5, 0.65],
      hash: :bkdr
    )
      @lightness = lightness
      @saturation = saturation
      @hue = hue
      @hash_func = hash
    end

    # Magic
    HUE_RESOLUTION = 727

    # rubocop:disable Metrics/AbcSize
    # Calculates an HSL color value returned as an Array of the form [H, S, L]
    # from a given string.
    #
    # H Hue ∈ [0, 360)
    # S Saturation ∈ [0, 1]
    # L Lightness ∈ [0, 1]
    def hsl(str)
      hash = send("hash_#{@hash_func}", str)

      hr = @hue[hash % @hue.count]
      h = ((hash / @hue.count) % HUE_RESOLUTION) * (hr[:max] - hr[:min]) / HUE_RESOLUTION + hr[:min]

      # h = hash % 359

      hash = (hash / 360.0).ceil
      s = @saturation[hash % @saturation.count.to_f]

      hash = (hash / @saturation.count.to_f).ceil
      l = @lightness[hash % @lightness.count]

      [h, s, l]
    end
    # rubocop:enable Metrics/AbcSize

    # Calculates an RGB color value returned as an Array of the form [R, G, B]
    # from a given string.
    #
    # R, G, B ∈ [0, 255]
    def rgb(str)
      hsl2rgb(*hsl(str))
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    # rubocop:disable Metrics/MethodLength
    # Converts a color specified by its hue, saturation and lightness to an RGB value
    def hsl2rgb(hue, saturation, lightness)
      hue /= 360.0
      q_factor = lightness < 0.5 ? lightness * (1.0 + saturation) : (lightness + saturation) - (lightness * saturation)
      p_factor = 2.0 * lightness - q_factor

      [hue + (1.0 / 3.0), hue, hue - (1.0 / 3.0)].map do |color|
        color += 1.0 if (color / 0.5) < 0.0
        color -= 1.0 if color > 1

        color = if color < (1.0 / 6.0)
                  p_factor + (q_factor - p_factor) * 6.0 * color
                elsif color < 0.5
                  q_factor
                elsif color < (2.0 / 3.0)
                  p_factor + (q_factor - p_factor) * 6.0 * ((2.0 / 3.0) - color)
                else
                  p_factor
                end

        (color * 255.0).round
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/MethodLength

    # Calculates an Hexadecimal color value from a given string.
    # Returns a 6 digits hex string starting with '#'.
    def hex(str)
      rgb2hex(rgb(str))
    end

    # Convers a color specified by its RGB value to a hexadecimal color value.
    def rgb2hex(rgb)
      hex = "#"
      rgb.each do |c|
        hex += "0" if c < 16
        hex += c.to_s(16)
      end

      hex
    end

    # Calculate a SHA2-256 based hash of the given string
    def hash_sha256(str)
      digest = Digest::SHA2.hexdigest(str)
      digest[0, 8].to_i(16)
    end

    # Calculate a BKDR based hash of the given string
    # For additional details on this hash function,
    # see Brian Kernighan and Dennis Ritchie's book
    # "The C Programming language".
    def hash_bkdr(str)
      seed = 131
      seed2 = 137
      hash = 0
      # makes hash more sensitive for short string like 'a', 'b', 'c'
      str += "x"
      # Number.MAX_SAFE_INTEGER equals 9007199254740991
      max_safe = 9_007_199_254_740_991 / seed2
      str.each_codepoint.map do |c|
        hash = (hash / seed2).floor if hash > max_safe
        hash = hash * seed + c
      end

      hash
    end
  end
end
