class UsersDecorator
  def initialize(owner:, logged:, users:, action:, fields:)
    @owner = owner
    @logged = logged
    @users = users
    @action = action
    @fields = fields
  end

  def prepare
    @users ||= []
    @users = User.find(@users) if @users.any?

    add_logged
    add_owner

    @fields.to_h.merge(users_list)
  end

  private

  def creating_action?
    @action == :create
  end

  def updating_action?
    @action == :update
  end

  def add_logged
    @users.push(@logged) if creating_action? || @owner == @logged
  end

  def add_owner
    @users.push(@owner) if updating_action? && @owner != @logged
  end

  def users_list
    list = { users: @users }

    list.merge!({ owner: @logged }) if creating_action?

    list
  end
end
