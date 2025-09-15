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

    private var _dc as Graphics.Dc;
    private var _timeFont as Graphics.FontType;
    private var _dateFont as Graphics.FontType;

    private var _locX as Lang.Number;
    private var _locY as Lang.Number;
    private var _dateLocX as Lang.Number;
    private var _dateLocY as Lang.Number;
    private var _hourString as Lang.String;
    private var _minString as Lang.String;
    private var _date as Lang.Number;
    private var _month as Lang.Number;

    function initialize(options as Options, dc as Graphics.Dc) {
        _dc = dc;
        _locX = options[:locX];
        _locY = options[:locY];
        _timeFont = Graphics.FONT_SYSTEM_NUMBER_THAI_HOT;
        _dateFont = Graphics.FONT_SYSTEM_XTINY;

        var clockTime = System.getClockTime();
        _hourString = formatHour(clockTime.hour);
        _minString = formatMin(clockTime.min);
        var today = Time.Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        _date = today.day;
        _month = today.month - 1;

        var timeAdjustmentHeight = dc.getFontHeight(_timeFont) / 2;
        var dateAdjustmentHeight = dc.getFontHeight(_dateFont);

        _locY = options[:locY] - timeAdjustmentHeight - dateAdjustmentHeight;

        _dateLocX = options[:locX];
        _dateLocY = options[:locY] + dateAdjustmentHeight;
    }

    function update() as Void {
        var hourWidth = _dc.getTextWidthInPixels(_hourString, _timeFont);
        var minuteWidth = _dc.getTextWidthInPixels(_minString, _timeFont);
        var hourStart = _locX - ((hourWidth + minuteWidth) / 2);
        _dc.setColor(CYAN, Graphics.COLOR_BLACK);
        _dc.drawText(hourStart, _locY, _timeFont, _hourString, Graphics.TEXT_JUSTIFY_LEFT);

        _dc.setColor(PURPLE, Graphics.COLOR_BLACK);
        _dc.drawText(hourStart + hourWidth, _locY, _timeFont, _minString, Graphics.TEXT_JUSTIFY_LEFT);

        _dc.setColor(YELLOW, Graphics.COLOR_BLACK);
        _dc.drawText(_dateLocX, _dateLocY, _dateFont, MONTHS[_month].toUpper() + " " + _date, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
