include Java

import java.awt.event.WindowListener

class CloseListener
	def initialize interpolator
		@interpolator = interpolator
	end

	def windowClosing e
		@interpolator.refresh
    end

    def windowActivated e
    end
    def windowClosed e
    end
    def windowDeactivated e
    end
    def windowDeiconified e
    end
    def windowGainedFocus e
    end
    def windowIconified e
    end
    def windowLostFocus e
    end
    def windowOpened e
    end
    def windowStateChanged e
    end
end