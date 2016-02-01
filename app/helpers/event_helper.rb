#:nodoc:
module EventHelper
  def event_icons_select
    Fonts.new.list.collect { |f| [f.strip, f.strip] }
  end
end
