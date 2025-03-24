import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

class TimeView {
    typedef Options as {
        :locX as Lang.Number,
        :locY as Lang.Number
    };

    private var _locX as Lang.Number;
    private var _locY as Lang.Number;
    private var _dateLocX as Lang.Number;
    private var _dateLocY as Lang.Number;
    private var _hourString as Lang.String;
    private var _minString as Lang.String;
    private var _date as Lang.Number;
    private var _month as Lang.Number;

    function initialize(options as Options, dc as Graphics.Dc) {
        var clockTime = System.getClockTime();
        _hourString = formatHour(clockTime.hour);
        _minString = formatMin(clockTime.min);
        var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        _date = today.day;
        _month = today.month - 1;

         var adjustmentWidth = _hourString.length() == 1
           ? dc.getTextWidthInPixels(_minString.substring(0,1), Graphics.FONT_SYSTEM_NUMBER_THAI_HOT)
           : 0;

        var timeAdjustmentHeight = dc.getFontHeight(Graphics.FONT_SYSTEM_NUMBER_THAI_HOT) / 2;
        var dateAdjustmentHeight = dc.getFontHeight(Graphics.FONT_SYSTEM_XTINY);

        _locX = options[:locX] - adjustmentWidth / 2;
        _locY = options[:locY] - timeAdjustmentHeight - dateAdjustmentHeight;


        _dateLocX = options[:locX];
        _dateLocY = options[:locY] + dateAdjustmentHeight;
    }

    function update(hoursLayout as WatchUi.Text, minutesLayout as WatchUi.Text, dateLayout as WatchUi.Text) as Void {
        hoursLayout.setText(_hourString);
        hoursLayout.setLocation(_locX, _locY);
        hoursLayout.setColor(CYAN);

        minutesLayout.setText(_minString);
        minutesLayout.setLocation(_locX, _locY);
        minutesLayout.setColor(PURPLE);

        dateLayout.setText(MONTHS[_month].toUpper() + " " + _date);
        dateLayout.setLocation(_dateLocX, _dateLocY);
        dateLayout.setColor(YELLOW);
    }
}
