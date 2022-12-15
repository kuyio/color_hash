# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
RSpec.describe ColorHash do
  it "has a version number" do
    expect(ColorHash::VERSION).not_to be nil
  end

  context "with default options" do
    let(:ch) { ColorHash.new }

    it "calculates a hex color from a given string" do
      expect(ch.hex("Hello World!")).to eq("#79d2b3")
    end

    it "calculates an HSL color from a given string" do
      expect(ch.hsl("Hello World!")).to eq([159, 0.5, 0.65])
    end

    it "calculates an RGB color from a given string" do
      expect(ch.rgb("Hello World!")).to eq([121, 210, 179])
    end
  end

  context "with a given hue range" do
    let(:ch) { ColorHash.new(hue: [{ min: 180, max: 240 }]) }

    it "calculates an HSL color from a given string that falls into the specified hue range" do
      h, _s, _l = ch.hsl("Hello World!")

      expect(h).to be > 180
      expect(h).to be < 240
    end
  end

  context "with a given saturation" do
    let(:ch) { ColorHash.new(saturation: [0.5]) }

    it "calculates an HSL color from a given string that falls into the specified saturation" do
      _h, s, _l = ch.hsl("Hello World!")
      expect(s).to eq(0.5)
    end
  end

  context "with a given lightness" do
    let(:ch) { ColorHash.new(lightness: [0.5]) }

    it "calculates an HSL color from a given string that falls into the specified lightness" do
      _h, _s, l = ch.hsl("Hello World!")
      expect(l).to eq(0.5)
    end
  end
end
# rubocop:enable Metrics/BlockLength
