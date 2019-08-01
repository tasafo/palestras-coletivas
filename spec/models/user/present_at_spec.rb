require 'spec_helper'

describe User, '.present_at? event', type: :model do
  subject(:user) { create(:user, :paul) }
  let(:billy) { create :user, :billy }
  let(:event) { create(:event, :tasafoconf, owner: billy) }

  context 'when user does not have enrollment' do
    it 'search for enrollment' do
      expect(Enrollment)
        .to receive(:find_by)
        .with(user: user, event: event)
        .and_return(nil)
      user.present_at? event
    end

    it 'returns false' do
      expect(user.present_at?(event)).to be false
    end
  end

  context 'when user have enrollment' do
    let!(:enrollment) do
      Enrollment.create(user: user, event: event, active: true)
    end

    context 'when user is not present at event' do
      it 'search for enrollment' do
        expect(Enrollment)
          .to receive(:find_by)
          .with(user: user, event: event)
          .and_return(enrollment)

        user.present_at? event
      end

      it 'returns false' do
        expect(user.present_at?(event)).to be false
      end
    end

    context 'when user is present at event' do
      before do
        enrollment.present = true
        enrollment.save
      end

      it 'returns true' do
        expect(user.present_at?(event)).to be true
      end
    end
  end
end
