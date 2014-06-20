require "spec_helper"

describe ExternalEvent, "validations", :type => :model do
  context "when valid data" do
    let(:external_event) { build(:external_event, :fisl) }

    it "accepts valid attributes" do
      expect(external_event).to be_valid
    end
  end

  it "requires name" do
    external_event = ExternalEvent.create(:name => nil)

    expect(external_event.errors[:name].size).to eq(1)
  end

  it "requires place" do
    external_event = ExternalEvent.create(:place => nil)

    expect(external_event.errors[:place].size).to eq(1)
  end

  it "requires date" do
    external_event = ExternalEvent.create(:date => nil)

    expect(external_event.errors[:date].size).to eq(1)
  end  
end