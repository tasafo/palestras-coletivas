require "spec_helper"

describe Talk, "validations" do
  let!(:comment)  { create(:comment, :talk) }

  context "when valid data" do
    it "accepts valid attributes" do
      expect(comment).to be_valid
    end
  end

  it "requires body" do
    comment.body = nil

    expect(comment).to have(1).error_on(:body)
  end

  it "requires user" do
    comment.user = nil

    expect(comment).to have(1).error_on(:user)
  end
end