#:nodoc:
class PersistenceController < ApplicationController
  def save_object(object, users, args = {})
    object_name = object.class.name.downcase

    option = :edit
    operation = :update
    if args[:owner]
      option = :new
      operation = :create
    end

    decorator = get_decorator(object, users, args)

    if decorator.send operation
      name = object_name.pluralize
      redirect_to "/#{name}/#{object._slugs[0]}",
                  notice: t("flash.#{name}.#{operation}.notice")
    else
      render option
    end
  end

  private

  def get_decorator(object, users, args)
    eval("#{object.class.name}Decorator").new(object, users, args)
  end
end
