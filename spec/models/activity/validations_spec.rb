require "spec_helper"

describe Activity, "validations", :type => :model do
  context "when valid data" do
    let!(:activity) { create(:activity, :palestra) }

    it "accepts valid attributes" do
      expect(activity).to be_valid
    end
  end

  it "requires type" do
    activity = Activity.create(:type => nil)

    expect(activity.errors[:type].size).to eq(1)
  end

  it "requires description" do
    activity = Activity.create(:description => nil)

    expect(activity.errors[:description].size).to eq(1)
  end

  it "requires order" do
    activity = Activity.create(:order => nil)

    expect(activity.errors[:order].size).to eq(1)
  end
end