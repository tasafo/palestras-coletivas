require "spec_helper"

describe Activity, "validations" do
  context "when valid data" do
    let!(:activity) { create(:activity, :palestra) }

    it "accepts valid attributes" do
      expect(activity).to be_valid
    end
  end

  it "requires type" do
    activity = Activity.create(:type => nil)

    expect(activity).to have(1).error_on(:type)
  end

  it "requires description" do
    activity = Activity.create(:description => nil)

    expect(activity).to have(1).error_on(:description)
  end

  it "requires order" do
    activity = Activity.create(:order => nil)

    expect(activity).to have(1).error_on(:order)
  end
end