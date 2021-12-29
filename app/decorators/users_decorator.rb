class UsersDecorator
  def initialize(object, users, args = {})
    @object = object
    @users = users
    @owner = args[:owner]
    @params = args[:params]
  end

  def create
    @object.owner = @owner
    @object.users << @owner

    update_users

    @object.save
  end

  def update
    update_users

    @object.update(@params)
  end

  private

  def update_users
    clean_attributes

    if @users
      @form_users = User.find(@users)

      add_users
    end

    del_users
  end

  def add_users
    users_add = @form_users.reject { |form_user| find_user_in_object(form_user) }

    @object.users << users_add if users_add
  end

  def find_user_in_object(form_user)
    found = @object.users.select { |object_user| object_user.id == form_user.id }

    found.any?
  end

  def del_users
    @object.users.each do |object_user|
      next if object_user.id == @object.owner.id

      remove_user(object_user)
    end
  end

  def remove_user(object_user)
    user_remove = find_user_in_form(object_user)

    begin
      @object.pull(users: user_remove) if user_remove
    rescue BSON::Error::UnserializableClass
      nil
    end
  end

  def find_user_in_form(object_user)
    return object_user unless @users

    found = @form_users.select { |form_user| form_user.id == object_user.id }

    found.empty? ? object_user : false
  end
end
