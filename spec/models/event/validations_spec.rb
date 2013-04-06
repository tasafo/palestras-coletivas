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

  it "requires deadline date enrollment" do
    event = Event.create(:deadline_date_enrollment => nil)

    expect(event).to have(1).error_on(:deadline_date_enrollment)
  end
  
  it "requires place" do
    event = Event.create(:place => nil)

    expect(event).to have(1).error_on(:place)
  end

  it "requires street" do
    event = Event.create(:street => nil)

    expect(event).to have(1).error_on(:street)
  end

  it "requires district" do
    event = Event.create(:district => nil)

    expect(event).to have(1).error_on(:district)
  end

  it "requires city" do
    event = Event.create(:city => nil)

    expect(event).to have(1).error_on(:city)
  end

  it "requires state" do
    event = Event.create(:state => nil)

    expect(event).to have(1).error_on(:state)
  end

  it "requires country" do
    event = Event.create(:country => nil)

    expect(event).to have(1).error_on(:country)
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