class PersistenceController < ApplicationController
  def save_object(object, users, args = {})
    object_name = object.class.to_s.downcase

    if args[:owner]
      commands = {render: :new, operation: :create} 
    else
      commands = {render: :edit, operation: :update}
    end
    
    if eval("#{object_name.titleize}Decorator").new(object, users, args).send commands[:operation]
      redirect_to "/#{object_name.pluralize}/#{object._slugs[0]}", notice: t("flash.#{object_name.pluralize}.#{commands[:operation].to_s}.notice")
    else
      render commands[:render]
    end
  end
end