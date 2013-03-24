require "spec_helper"

describe Group, "validations" do
  context "when valid data" do
    let!(:user) { create(:user, :paul) }
    let!(:group) { create(:group, :tasafo, :users => [ user ], :owner => user.id) }

    it "accepts valid attributes" do
      expect(group).to be_valid
    end
  end

  it "requires name" do
    group = Group.create(:name => nil)

    expect(group).to have(1).error_on(:name)
  end

  it "requires tags" do
    group = Group.create(:tags => nil)

    expect(group).to have(1).error_on(:tags)
  end

  it "requires owner" do
    group = Group.create(:owner => nil)

    expect(group).to have(1).error_on(:owner)
  end
end