require "spec_helper"

describe Event, "validations" do
  context "when valid data" do
    let!(:user) { create(:user, :paul) }
    let!(:other_user) { create(:user, :billy) }
    let!(:event) {
      create(
        :event,
        :tasafoconf,
        :users => [ user, other_user ],
        :owner => user.id
      )
    }

    it "accepts valid attributes" do
      expect(event).to be_valid
    end
  end

  it "requires name" do
    event = Event.create(:name => nil)

    expect(event).to have(1).error_on(:name)
  end

  it "requires edition" do
    event = Event.create(:edition => nil)

    expect(event).to have(1).error_on(:edition)
  end

  it "requires tags" do
    event = Event.create(:tags => nil)

    expect(event).to have(1).error_on(:tags)
  end

  it "requires start date" do
    event = Event.create(:start_date => nil)

    expect(event).to have(1).error_on(:start_date)
  end

  it "requires end date" do
    event = Event.create(:end_date => nil)

    expect(event).to have(1).error_on(:end_date)
  end

  it "requires place" do
    event = Event.create(:place => nil)

    expect(event).to have(1).error_on(:place)
  end

  it "requires address" do
    event = Event.create(:address => nil)

    expect(event).to have(1).error_on(:address)
  end
  
  it "requires owner" do
    event = Event.create(:owner => nil)

    expect(event).to have(1).error_on(:owner)
  end

  it "requires stocking" do
    event = Event.create(:stocking => nil)

    expect(event).to have(1).error_on(:stocking)
  end
end