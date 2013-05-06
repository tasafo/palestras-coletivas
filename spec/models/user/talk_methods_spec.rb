require "spec_helper"

describe User, "talk methods" do
  let!(:user)         { create(:user, :paul) }
  let!(:talk)         { create(:talk, :users => [ user ], :owner => user.id.to_s) }
  let!(:regular_user) { create(:user, :luis) }

  describe "toggle_watch_talk!" do
    context "when talk was already watched" do 
      before do
        regular_user.toggle_watch_talk! talk
      end

      it "marks talk as not watched" do
        expect(regular_user.watched_talk? talk).to be_true
        regular_user.toggle_watch_talk! talk
        expect(regular_user.watched_talk? talk).to be_false
      end
    end

    context "when talk was already watched" do 
      it "marks talk as watched" do
        expect(regular_user.watched_talk? talk).to be_false
        regular_user.toggle_watch_talk! talk
        expect(regular_user.watched_talk? talk).to be_true
      end
    end
  end

  describe "watched_talk?" do
    context "when user watched talk" do
      it "returns true" do
        regular_user.toggle_watch_talk! talk
        expect(regular_user.watched_talk? talk).to be_true
      end
    end

    context "when user did not watch talk" do
      it "returns false" do
        expect(regular_user.watched_talk? talk).to be_false
      end
    end
  end
end