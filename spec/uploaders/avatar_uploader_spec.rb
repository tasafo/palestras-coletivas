require 'spec_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader do
  include CarrierWave::Test::Matchers

  let(:user) { double('user') }
  let(:uploader) { AvatarUploader.new(user, :avatar) }

  before do
    AvatarUploader.enable_processing = true
    File.open("#{Rails.root}/app/assets/images/without_avatar.jpg") { |f| uploader.store!(f) }
  end

  after do
    AvatarUploader.enable_processing = false
    uploader.remove!
  end

  it "has the correct format" do
    expect(uploader).to be_format('JPEG')
  end
end