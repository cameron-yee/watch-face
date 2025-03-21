import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.WatchUi;

class TimeView {
    typedef Options as {
        :locX as Lang.Number,
        :locY as Lang.Number
    };

    private var _locX as Lang.Number;
    private var _locY as Lang.Number;
    private var _hourString as Lang.String;
    private var _minString as Lang.String;

    function initialize(options as Options, dc as Graphics.Dc) {
        var clockTime = System.getClockTime();
        _hourString = formatHour(clockTime.hour);
        _minString = formatMin(clockTime.min);

         var adjustmentWidth = _hourString.length() == 1
           ? dc.getTextWidthInPixels(_minString.substring(0,1), Graphics.FONT_SYSTEM_NUMBER_THAI_HOT)
           : 0;

        _locX = options[:locX] - adjustmentWidth / 2;
        _locY = options[:locY];
    }

    function update(hoursLayout as WatchUi.Text, minutesLayout as WatchUi.Text) as Void {
        hoursLayout.setText(_hourString);
        hoursLayout.setLocation(_locX, _locY);
        hoursLayout.setColor(CYAN);
        minutesLayout.setText(_minString);
        minutesLayout.setLocation(_locX, _locY);
        minutesLayout.setColor(PURPLE);
    }
}
