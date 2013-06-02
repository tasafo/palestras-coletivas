require "spec_helper"

describe ExternalEvent, "validations" do
  context "when valid data" do
    let(:external_event) { build(:external_event, :fisl) }

    it "accepts valid attributes" do
      expect(external_event).to be_valid
    end
  end

  it "requires name" do
    external_event = ExternalEvent.new(:name => nil)

    expect(external_event).to have(1).error_on(:name)
  end

  it "requires place" do
    external_event = ExternalEvent.new(:place => nil)

    expect(external_event).to have(1).error_on(:place)
  end

  it "requires date" do
    external_event = ExternalEvent.new(:date => nil)

    expect(external_event).to have(1).error_on(:date)
  end  
end