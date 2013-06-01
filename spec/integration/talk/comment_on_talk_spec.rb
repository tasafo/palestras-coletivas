require "spec_helper"

describe "Comment on talk" do
  let!(:user) { create(:user, :paul) }
  let!(:commentor) { create(:user, :billy) }
  let!(:talk) { create(:talk, :users => [ user ], :owner => user.id) }

  before do
    login_as(commentor)
    visit talk_path(talk)
  end

  context "with valid comment" do
    it "comment on a talk" do
      within(".new_comment_form") do
        fill_in "comment_body", :with => "Muito massa!"
        click_button I18n.t("actions.comment")
      end

      expect(page.current_path).to eql talk_path talk
      expect(page).to have_content I18n.t("flash.comments.create.notice")
      expect(page).to have_selector "article.comment a[href='#{user_path(commentor)}']"
      expect(page).to have_content "Muito massa!"
    end

    it "comment on a comment" do
      within(".new_comment_form") do
        fill_in "comment_body", :with => "Muito massa!"
        click_button I18n.t("actions.comment")
      end

      comment = talk.reload.comments.first

      within("#comment_#{comment.id}") do
        click_link "Responder"

        fill_in "comment_body", :with => "Também achei!"
        click_button I18n.t("actions.answer")
      end

      expect(page.current_path).to eql talk_path talk
      expect(page).to have_content I18n.t("flash.comments.create.notice")
      expect(page).to have_selector "#comment_#{comment.id} a[href='#{user_path(commentor)}']"
      expect(page).to have_content "Também achei!"
    end
  end

  context "when user owns a comment" do
    it "he/she can delete comments" do
      within(".new_comment_form") do
        fill_in "comment_body", :with => "Muito massa!"
        click_button I18n.t("actions.comment")
      end

      comment = talk.reload.comments.first

      within("#comment_#{comment.id}") do
        click_link "Responder"

        fill_in "comment_body", :with => "Também achei!"
        click_button I18n.t("actions.answer")
      end

      answer = comment.reload.comments.first

      find("#answer_#{answer.id} a.delete").click()
      expect(page.current_path).to eql talk_path talk
      expect(page).to              have_content I18n.t("flash.comments.destroy.notice")
      expect(page).to_not          have_content answer.body

      find("#comment_#{comment.id} a.delete").click()
      expect(page.current_path).to eql talk_path talk
      expect(page).to              have_content I18n.t("flash.comments.destroy.notice")
      expect(page).to_not          have_content comment.body
    end
  end

  context "with invalid comment" do
    it "comment on a talk" do
      within(".new_comment_form") do
        fill_in "comment_body", :with => ""
        click_button I18n.t("actions.comment")
      end

      expect(page.current_path).to eql talk_path talk
      expect(page).to have_content I18n.t("flash.comments.create.alert")
      expect(page).to_not have_selector "article.comment a[href='#{user_path(commentor)}']"
    end
  end
end