require_relative 'platform_factory'

class App

  attr_reader :platform

  attr_reader :current_state, :all_states

  # config
  attr_accessor :work_length_in_minutes, :break_lengths_in_minutes

  def initialize()
    @platform = PlatformFactory.create_platform()

    @all_states = {
        :NOT_RUNNING => StateNotRunning.new(self),
        :WORKING => StateWorking.new(self),
        :BREAK => StateBreak.new(self)
    }

    @work_length_in_minutes = 45
    @break_lengths_in_minutes = [3, 5, 10]

    @platform.add_menu_item("Take a Break") do
      set_state(:BREAK)
    end

    @platform.add_menu_item("Back to work") do
      set_state(:WORKING)
    end

    @platform.add_menu_item_separator()
    @platform.add_menu_item("Quit") do
      @platform.exit()
    end

    set_state(:WORKING)
  end

  def set_state(state)
    if (@current_state != nil)
      @current_state.deactivate()
    end
    @current_state = @all_states[state]
    @current_state.activate()
  end

  def run()
    @platform.run()
  end

end

class StateNotRunning
  def initialize(app)
    @app = app
  end

  def activate
    @app.platform.set_icon(:ICON_NOT_RUNNING)
    @app.platform.set_label("--:--")
  end

  def deactivate
  end
end

class StateWorking
  def initialize(app)
    @app = app
  end

  def activate
    @is_active = true
    @user_notified = false
    @work_start = Time.now

    @app.platform.set_icon(:ICON_NORMAL)
    @app.platform.set_label("00:00")

    @app.platform.add_timeout(60) do
      if @is_active
        diff_in_seconds = Time.now - @work_start

        if (diff_in_seconds / 60 > @app.work_length_in_minutes)
          if !@user_notified
            @user_notified = true
            @app.platform.set_icon(:ICON_ATTENTION)
            @app.platform.notify("Time for break", "You should take a short break now.", 2.5)
          end
        end

        @app.platform.set_label(sprintf("%02d:%02d", diff_in_seconds / 3600, (diff_in_seconds % 3600) / 60))
      end
      @is_active
    end
  end

  def deactivate
    @is_active = false
  end

end

class StateBreak
  def initialize(app_context)
    @app = app_context
  end

  def activate
    @is_active = true
    @user_notified = {}
    @break_start = Time.now
    @app.platform.set_icon(:ICON_BREAK)
    @app.platform.set_label("00:00")

    @app.platform.add_timeout(1) do
      if @is_active
        diff_in_seconds = Time.now - @break_start
        diff_in_minutes = diff_in_seconds / 60
        # go through break length list from largest to smallest
        for break_length in @app.break_lengths_in_minutes.sort.reverse
          if diff_in_minutes > break_length && !@user_notified[break_length]
            @app.platform.notify("#{break_length} minutes are up", "Do you want to work now?", 2.5)
            @user_notified[break_length] = true
          end
        end

        @app.platform.set_label(sprintf("%02d:%02d", (diff_in_seconds % 3600) / 60, diff_in_seconds % 60))
      end
      @is_active
    end
  end

  def deactivate
    @is_active = false
  end
end

