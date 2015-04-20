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
      enrollment = user.enroll_at(event)

      expect(enrollment).to be_valid
    end

    it ".arrived_at event" do
      expect(subject.arrived_at(event)).to be true
    end
  end

  describe "user have Enrollment" do
    before do
      2.times do
        enrollment = Enrollment.new(user: subject, event: event, active: true)
        enrollment = EnrollmentDecorator.new(enrollment, 'active').create
      end
    end

    it ".arrived_at event" do
      expect(subject.enroll_at(event)).to be false
    end
  end
end