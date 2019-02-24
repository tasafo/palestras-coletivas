#:nodoc:
class PersistenceController < ApplicationController
  def save_object(object, users, args = {})
    name = object.class.name.downcase.pluralize
    option = args[:owner] ? :new : :edit
    operation = args[:owner] ? :create : :update

    decorator = decorate(object, users, args)

    if decorator.send operation
      redirect_to "/#{name}/#{object.slug}",
                  notice: t("flash.#{name}.#{operation}.notice")
    else
      render option
    end
  end

  def destroy_object(object)
    name = object.class.name.downcase

    object.destroy

    if object.errors.blank?
      redirect_to "/#{name.pluralize}", notice: text_notice(name, true)
    else
      redirect_to "/#{name.pluralize}/#{object.slug}",
                  notice: text_notice(name, false)
    end
  end

  private

  def decorate(object, users, args)
    klass = "#{object.class.name}Decorator".constantize

    klass.new(object, users, args)
  end

  def text_notice(name, error)
    if error
      t('notice.destroyed', model: t("mongoid.models.#{name}"))
    else
      t("notice.delete.restriction.#{name.pluralize}")
    end
  end
end
