#:nodoc:
class PersistenceController < ApplicationController
  def save_object(object, users, args = {})
    object_name = object.class.name.downcase

    option = args[:owner] ? :new : :edit
    operation = args[:owner] ? :create : :update

    decorator = get_decorator(object, users, args)

    if decorator.send operation
      name = object_name.pluralize
      redirect_to "/#{name}/#{object._slugs[0]}",
                  notice: t("flash.#{name}.#{operation}.notice")
    else
      render option
    end
  end

  def destroy_object(object)
    name = object.class.name.downcase

    object.destroy

    if object.errors.blank?
      redirect_to "/#{name.pluralize}",
                  notice: t('notice.destroyed',
                            model: t("mongoid.models.#{name}"))
    else
      redirect_to "/#{name.pluralize}/#{object.slug}",
                  notice: t("notice.delete.restriction.#{name.pluralize}")
    end
  end

  private

  def get_decorator(object, users, args)
    klass = "#{object.class.name}Decorator".constantize

    klass.new(object, users, args)
  end
end
