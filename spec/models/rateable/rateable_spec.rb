require 'spec_helper'

describe Rateable, :type => :model do
  class DummyEvent
    include Mongoid::Document
    include Rateable
    embeds_many :ratings, :as => :rateable
  end

  subject { DummyEvent.new }
  let(:user)  { create :user, :billy }
  let(:other_user)  { create :user, :paul }

  it "#rating_by" do
    subject.save
    rating_1 = subject.rate_by user, 4
    rating_2 = subject.rate_by other_user, 4

    expect(subject.rating_by other_user).to be_eql rating_2
  end

  it "adds rating by user" do
    subject.save
    rating = subject.rate_by user, 4

    expect(rating.rank).to eq(4)
    expect(rating.user).to eq(user)
    expect(subject.ratings.size).to be_eql 1
  end

  it "adds one rating only by user" do
    subject.save
    rating = subject.rate_by user, 4
    rating = subject.rate_by user, 2
    rating = subject.rate_by user, 1

    expect(rating.rank).to eq(1)
    expect(rating.user).to eq(user)
    expect(subject.ratings.size).to be_eql 1
  end

  context "when calculating rating" do
    before do
      subject.ratings.build :rank => 4
      subject.ratings.build :rank => 3.5
      subject.ratings.build :rank => 3.5
    end

    it "calculates mean with step 0.5" do
      expect(subject.rating).to be_eql 3.5
    end

    it "returns 0 if rateable has no rating" do
      subject.ratings.destroy_all
      expect(subject.rating).to be_eql 0
    end
  end
end