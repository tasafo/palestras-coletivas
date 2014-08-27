shared_examples "a rateable" do
  let!(:user) { create(:user, :paul) }
  let!(:guest) { create(:user, :billy) }

  before do
    login_as(guest)
    visit rateable_path
  end

  context "when a user add a rating" do
    it "calculates rating for rateable" do
      add_rating(2.5)
      rateable.reload
      expect(rateable.ratings.size).to be == 1
      assert_rating 2.5

      add_rating(3.0)
      rateable.reload
      expect(rateable.ratings.size).to be == 1
      assert_rating 3.0

      login_as_other_user user

      add_rating(4.0)
      rateable.reload
      expect(rateable.ratings.size).to be == 2
      assert_rating (3 + 4) / 2.0
    end

    def assert_rating rating
      expect(rateable.rating).to be == rating
      #expect(page).to have_selector(".rating .readonly[checked='checked'][value='#{rating}']")
      expect(page.has_checked_field?("rate_my_rating_#{(rating * 10).to_i}"))
    end

    def add_rating rating
      find(".rating_form .star-rating a[title='#{rating}']").click
      visit rateable_path
    end

    def login_as_other_user user
      visit("/logout")
      login_as(user)
      visit rateable_path
    end
  end
end