class PersistenceController < ApplicationController
  def save_object(object, users, args = {})
    name = object.class.name.downcase.pluralize
    owner = args[:owner]
    option = option_type(owner)
    operation = operation_type(owner)
    decorator = decorate(object, users, args)

    if decorator.send(operation)
      redirect_to "/#{name}/#{object.slug}", notice: t("flash.#{name}.#{operation}.notice")
    else
      render option
    end
  end

  def destroy_object(object)
    name = object.class.name.downcase
    plural_name = name.pluralize

    object.destroy

    if object.errors.blank?
      redirect_to "/#{plural_name}", notice: error_text(name)
    else
      redirect_to "/#{plural_name}/#{object.slug}", notice: notice_text(name)
    end
  end

  private

  def decorate(object, users, args)
    klass = "#{object.class.name}Decorator".constantize

    klass.new(object, users, args)
  end

  def option_type(owner)
    owner ? :new : :edit
  end

  def operation_type(owner)
    owner ? :create : :update
  end

  def error_text(name)
    t('notice.destroyed', model: t("mongoid.models.#{name}"))
  end

  def notice_text(name)
    t("notice.delete.restriction.#{name.pluralize}")
  end
end
