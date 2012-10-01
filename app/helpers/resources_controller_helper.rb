module ResourcesControllerHelper

  def field_type(type)
    case type
    when :integer, :float, :decimal   then :text_field
    when :datetime, :timestamp, :time then :datetime_select
    when :date                        then :date_select
    when :string                      then :text_field
    when :text                        then :text_area
    when :boolean                     then :check_box
    else 
      :text_field
    end
  end

  def route_exists?(named_route, *args)
    self.send(named_route, *args)
  rescue Ardes::ResourcesController::CantMapRoute, NoMethodError, ActionController::RoutingError
    return false
  end

  alias   path_exists? route_exists?

  def link_to_if(anchor, named_route, *args)
    if route_exists?(named_route, *args)
      link_to(anchor, self.send(named_route, *args))
    end
  end


  def name_or_title(resource)
    if resource.respond_to?(:name)
      return resource.name
    elsif resource.respond_to?(:title)
      return resource.title
    else
      return nil
    end
  end

end
