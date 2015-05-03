module EventHelper
  def event_icons_select
    Fonts.list.collect {|f| [f.strip, f.strip]}
  end
end