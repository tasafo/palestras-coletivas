require "spec_helper"

describe Schedule, "validations" do
  context "when valid data" do
    let!(:user) { create(:user, :paul) }
    let!(:event) { create(:event, :tasafoconf, :users => [ user ], :owner => user.id) }
    let!(:schedule) { create(:schedule, :abertura, :event => event) }

    it "accepts valid attributes" do
      expect(schedule).to be_valid
    end
  end

  it "requires date" do
    schedule = Schedule.create(:date => nil)

    expect(schedule).to have(1).error_on(:date)
  end

  it "requires time" do
    schedule = Schedule.create(:time => nil)

    expect(schedule).to have(1).error_on(:time)
  end

  it "requires event" do
    schedule = Schedule.create(:event => nil)

    expect(schedule).to have(1).error_on(:event)
  end

  it "requires session" do
    schedule = Schedule.create(:session => nil)

    expect(schedule).to have(1).error_on(:session)
  end
end