require "spec_helper"

describe Session, "validations" do
  context "when valid data" do
    let!(:session) { create(:session, :palestra) }

    it "accepts valid attributes" do
      expect(session).to be_valid
    end
  end

  it "requires type" do
    session = Session.create(:type => nil)

    expect(session).to have(1).error_on(:type)
  end

  it "requires description" do
    session = Session.create(:description => nil)

    expect(session).to have(1).error_on(:description)
  end

  it "requires order" do
    session = Session.create(:order => nil)

    expect(session).to have(1).error_on(:order)
  end
end