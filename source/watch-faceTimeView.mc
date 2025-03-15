import Toybox.Lang;
import Toybox.WatchUi;

class TimeView {
    typedef Options as {
        :locX as Lang.Number,
        :locY as Lang.Number
    };

    private var _locX as Lang.Number;
    private var _locY as Lang.Number;

    function initialize(options as Options) {
        _locX = options[:locX];
        _locY = options[:locY];
    }

    function getTimeString() as Lang.String {
        var clockTime = System.getClockTime();
        return formatHoursAndMinutes(clockTime.hour, clockTime.min);
    }

    function update(timeLayout as WatchUi.Text) as Void {
        timeLayout.setLocation(_locX, _locY);
        timeLayout.setText(getTimeString());
    }
}
