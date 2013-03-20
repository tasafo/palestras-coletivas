require "spec_helper"

describe Talk, "validations" do
  context "when valid data" do
    let!(:user) { create(:user, :paul) }
    let!(:talk) { create(:talk, :users => [ user ]) }

    it "accepts valid attributes" do
      expect(talk).to be_valid
    end
  end

  it "requires title" do
    talk = Talk.create(:title => nil)

    expect(talk).to have(1).error_on(:title)
  end

  it "requires description" do
    talk = Talk.create(:description => nil)

    expect(talk).to have(1).error_on(:description)
  end

  it "requires tags" do
    talk = Talk.create(:tags => nil)

    expect(talk).to have(1).error_on(:tags)
  end

  it "requires user" do
    talk = Talk.create(:users => nil)

    expect(talk).to have(1).error_on(:users)
  end
end