require "spec_helper"

describe User, "talk methods", :type => :model do
  let!(:user)         { create(:user, :paul) }
  let!(:talk)         { create(:talk, :users => [ user ], :owner => user.id.to_s) }
  let!(:regular_user) { create(:user, :luis) }

  describe "watch_talk!" do
    context "when talk was already watched" do 
      before do
        regular_user.watch_talk! talk
      end

      it "do not mark talk as watched twice" do
        regular_user.watch_talk! talk
        expect(regular_user.watched_talks.select { |w_talk| w_talk == talk }.size).to be_eql 1
      end
    end

    context "when talk was not watched" do 
      it "marks talk as watched" do
        expect(regular_user.watched_talk? talk).to be false
        regular_user.watch_talk! talk
        expect(regular_user.watched_talk? talk).to be true
      end

      it "increments watched talks counter" do
        expect(regular_user.counter_watched_talks).to be_eql 0
        regular_user.watch_talk! talk
        expect(regular_user.counter_watched_talks).to be_eql 1
      end
    end
  end

  describe "unwatch_talk!" do
    context "when talk was already watched" do 
      before do
        regular_user.watch_talk! talk
      end

      it "unmarks talk as watched" do
        expect(regular_user.watched_talk? talk).to be true
        regular_user.unwatch_talk! talk
        expect(regular_user.watched_talk? talk).to be false
      end

      it "decrements watched talks counter" do
        expect(regular_user.counter_watched_talks).to be_eql 1
        regular_user.unwatch_talk! talk
        expect(regular_user.counter_watched_talks).to be_eql 0
      end
    end

    context "when talk was not watched" do 
      it "makes no change" do
        expect(regular_user.watched_talk? talk).to be false
        regular_user.unwatch_talk! talk
        expect(regular_user.watched_talk? talk).to be false
      end
    end
  end

  describe "watched_talk?" do
    context "when user watched talk" do
      it "returns true" do
        regular_user.watch_talk! talk
        expect(regular_user.watched_talk? talk).to be true
      end
    end

    context "when user did not watch talk" do
      it "returns false" do
        expect(regular_user.watched_talk? talk).to be false
      end
    end
  end
end