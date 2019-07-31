shared_examples 'a commentable' do
  let!(:user) { create(:user, :paul) }
  let!(:commentor) { create(:user, :billy) }

  before do
    login_as(commentor)
    visit commentable_path
  end

  context 'with valid comment' do
    it 'on a commentable' do
      within('.new_comment_form') do
        fill_in 'comment_body', with: 'Muito massa!'
        click_button I18n.t('actions.comment')
      end

      expect(page.current_path).to eql commentable_path
      expect(page).to have_content I18n.t('flash.comments.create.notice')
      expect(page).to have_selector "article.comment a[href='#{user_path(commentor)}']"
      expect(page).to have_content 'Muito massa!'
    end

    it 'on a comment' do
      within('.new_comment_form') do
        fill_in 'comment_body', with: 'Muito massa!'
        click_button I18n.t('actions.comment')
      end

      comment = commentable.reload.comments.first

      within("#comment_#{comment.id}") do
        click_link 'Responder'

        fill_in 'comment_body', with: 'Também achei!'
        click_button I18n.t('actions.answer')
      end

      expect(page.current_path).to eql commentable_path
      expect(page).to have_content I18n.t('flash.comments.create.notice')
      expect(page).to have_selector "#comment_#{comment.id} a[href='#{user_path(commentor)}']"
      expect(page).to have_content 'Também achei!'
    end
  end

  context 'when user owns a comment' do
    it 'he/she can delete comments' do
      within('.new_comment_form') do
        fill_in 'comment_body', with: 'Muito massa!'
        click_button I18n.t('actions.comment')
      end

      comment = commentable.reload.comments.first

      within("#comment_#{comment.id}") do
        click_link 'Responder'

        fill_in 'comment_body', with: 'Também achei!'
        click_button I18n.t('actions.answer')
      end

      answer = comment.reload.comments.first

      find("#answer_#{answer.id} a.delete").click
      expect(page.current_path).to eql commentable_path
      expect(page).to              have_content I18n.t('flash.comments.destroy.notice')
      expect(page).to_not          have_content answer.body

      find("#comment_#{comment.id} a.delete").click
      expect(page.current_path).to eql commentable_path
      expect(page).to              have_content I18n.t('flash.comments.destroy.notice')
      expect(page).to_not          have_content comment.body
    end
  end

  context 'with invalid comment' do
    it 'show error message' do
      within('.new_comment_form') do
        fill_in 'comment_body', with: ''
        click_button I18n.t('actions.comment')
      end

      expect(page.current_path).to eql commentable_path
      expect(page).to have_content I18n.t('flash.comments.create.alert')
      expect(page).to_not have_selector "article.comment a[href='#{user_path(commentor)}']"
    end
  end
end
