# TODO: abstract class, jde zaridit, aby neslo instancovat?

class Platform

  def initialize_platform()
    raise_not_implemented
  end

  def add_menu_item(label, &handler)
    raise_not_implemented
  end

  def set_icon(icon)
    raise_not_implemented
  end

  def set_label(label)
    raise_not_implemented
  end

  def notify(title, body, timeout)
    raise_not_implemented
  end

  # TODO: comment, true jede dal
  def add_timeout(seconds, &block)
    raise_not_implemented
  end

  def run()
    raise_not_implemented
  end

  private

  def raise_not_implemented
    raise "This should be implemented by subclass on concrete platform."
  end

end