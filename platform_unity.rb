require 'ruby-libappindicator'
require 'libnotify'

require_relative "platform"

class PlatformUnity < Platform

  def initialize()
    @menu = Gtk::Menu.new

    @app_indicator = AppIndicator::AppIndicator.new("test", "watch-working", AppIndicator::Category::APPLICATION_STATUS);
    #@app_indicator.set_attention_icon("watch-attention")
    @app_indicator.set_menu(@menu)
  end

  def add_menu_item(label, &handler)
    menu_item = Gtk::MenuItem.new(label)
    menu_item.signal_connect("activate") do
      handler.call()
    end
    @menu.append(menu_item)

    # TODO:
    @menu.show_all()
  end

  def add_menu_item_separator()
    menu_item = Gtk::MenuItem.new()
    @menu.append(menu_item)

    # TODO:
    @menu.show_all()
  end

  def set_icon(icon)
    case icon
      when :ICON_BREAK
        @app_indicator.set_status(AppIndicator::Status::ACTIVE)
        @app_indicator.set_icon_full('watch-break', 'On break')
      when :ICON_NORMAL
        @app_indicator.set_status(AppIndicator::Status::ACTIVE)
        @app_indicator.set_icon_full('watch-working', 'Working')
      when :ICON_ATTENTION
        @app_indicator.set_status(AppIndicator::Status::ACTIVE)
        @app_indicator.set_icon_full('watch-attention', 'Attention')
      else
        raise "Unknown icon symbol: '#{icon}'."
    end
  end

  def set_label(label)
    # TODO: k cemu je ten guide?
    @app_indicator.set_label(label, "guide")
  end

  def notify(title, body, timeout)
    Libnotify.show(:summary => title, :body => body, :timeout => timeout)
  end

  def add_timeout(seconds, &block)
    GLib::Timeout.add_seconds(seconds) do
      block.call()
    end
  end

  def run()
    Gtk.main()
  end

  def exit()
    Gtk.main_quit()
  end

end