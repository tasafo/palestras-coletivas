require 'spec_helper'

describe User, ".arrived_at", :type => :model do
  subject(:user) { create(:user, :paul) }
  let(:billy) { create :user, :billy }
  let(:event) { create(:event, :tasafoconf, owner: billy.id ) }

  describe "user does not have subscribed" do

    it ".enrolled_at? event" do
      expect(Enrollment)
        .to receive(:find_by)
          .with(user: user, event: event)
            .and_return(nil)
      expect(subject.enrolled_at? event).to be false
    end

    it ".enroll_at" do
      expect(Enrollment)
        .to receive(:create)
          .with(user: user, event: event, active: true)
            .and_return(true)
      subject.enroll_at(event)
    end

    it ".arrived_at event" do
      expect(subject.arrived_at(event)).to be true
    end
  end

  describe "user have Enrollment" do
    before do
      enrollment = Enrollment.create(
        user: subject,
        event: event,
        active: true
      )
    end

    it ".arrived_at event" do
      expect(Enrollment).to receive(:find_by).with(user: subject, event: event)
      expect(subject.arrived_at(event)).to be false
    end
  end

end