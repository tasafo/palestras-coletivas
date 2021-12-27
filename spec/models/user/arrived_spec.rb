require 'spec_helper'

describe User, '.arrived_at' do
  subject(:user) { create(:user, :paul) }
  let(:billy) { create :user, :billy }
  let(:event) { create(:event, :tasafoconf, owner: billy.id) }

  describe 'user does not have subscribed' do
    it '.enroll_at' do
      enrollment = user.enroll_at(event)

      expect(enrollment).to be_valid
    end

    it '.arrived_at event' do
      expect(subject.arrived_at(event)).to be true
    end
  end

  describe 'user have Enrollment' do
    before do
      2.times do
        enrollment = event.enrollments.new(user: subject, active: true)
        EnrollmentDecorator.new(enrollment, 'active').create
      end
    end

    it '.arrived_at event' do
      expect(subject.enroll_at(event)).to be false
    end
  end
end
