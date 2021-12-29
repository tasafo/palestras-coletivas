class TalkDecorator < UsersDecorator
  def initialize(talk, users, args = {})
    super(talk, users, args)
  end

  def clean_attributes
    return unless @object.presentation_url.blank?

    @object.code = ''
    @object.thumbnail = ''
  end
end
