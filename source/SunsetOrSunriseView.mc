import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

class SunsetOrSunriseView {
    typedef Options as {
        :locX as Lang.Number,
        :locY as Lang.Number
    };

    private var _dc as Graphics.Dc;
    private var _locX as Lang.Number;
    private var _locY as Lang.Number;
    private var _hourString as Lang.String;
    private var _minString as Lang.String;
    private var _minuteAdjustmentWidth as Lang.Number;

    function getSunsetOrSunriseTimeInfo() as Time.Gregorian.Info or Null {
        var currentLocation = new ActivityInfoData().getCurrentLocation();

        if (currentLocation == null) {
            return null;
        }

        Application.Storage.setValue("coordinates", currentLocation.toDegrees());
        var nextSunriseOrSunset = new SunEvents(currentLocation).getNextSunriseOrSunset();

        if (nextSunriseOrSunset != null) {
            return Time.Gregorian.info(nextSunriseOrSunset, Time.FORMAT_LONG);
        }

        return null;
    }

    function initialize(options as Options, dc as Graphics.Dc) {
        _dc = dc;

        var timeInfo = getSunsetOrSunriseTimeInfo();
        _hourString = timeInfo != null ? formatHour(timeInfo.hour) : DEFAULT_STRING;
        _minString = timeInfo != null ? formatMin(timeInfo.min) : DEFAULT_STRING;

        _minuteAdjustmentWidth = dc.getTextWidthInPixels(_hourString, Graphics.FONT_MEDIUM);

        _locX = options[:locX];
        _locY = options[:locY];
    }

    function getNextSunEventColor() as Lang.Array<Graphics.ColorType> {
        var currentLocation = new ActivityInfoData().getCurrentLocation();

        if (currentLocation != null) {
            var nextSunEventIsSunrise = new SunEvents(currentLocation).isSunrise();
            if (nextSunEventIsSunrise) {
                return [MAGENTA, GRAY];
            }
        }

        return [PINK, GRAY];
    }

    function update() as Void {
        var colors = getNextSunEventColor();

        _dc.setColor(colors[0], Graphics.COLOR_BLACK);
        _dc.drawText(_locX, _locY, Graphics.FONT_MEDIUM, _hourString, Graphics.TEXT_JUSTIFY_LEFT);

        _dc.setColor(colors[1], Graphics.COLOR_BLACK);
        _dc.drawText(_locX + _minuteAdjustmentWidth, _locY, Graphics.FONT_MEDIUM , _minString, Graphics.TEXT_JUSTIFY_LEFT);
    }
}

