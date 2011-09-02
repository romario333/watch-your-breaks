require_relative "platform_unity"

class PlatformFactory

  def self.create_platform()
    return PlatformUnity.new()
  end

end