require 'spec_helper'
require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:event) { double('event') }
  let(:uploader) { ImageUploader.new(event, :image) }

  before do
    ImageUploader.enable_processing = true
    File.open("#{Rails.root}/app/assets/images/video-poster.jpg") { |f| uploader.store!(f) }
  end

  after do
    ImageUploader.enable_processing = false
    uploader.remove!
  end

  it "has the correct format" do
    expect(uploader).to be_format('JPEG')
  end
end