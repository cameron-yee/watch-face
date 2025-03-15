import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class SunsetOrSunriseView {
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

    function getSunsetOrSunriseString() as Lang.String {
        try {
            var currentLocation = new ActivityInfoData().getCurrentLocation();

            if (currentLocation != null) {
                Application.Storage.setValue("coordinates", currentLocation.toDegrees());
                var nextSunriseOrSunset = new SunEvents(currentLocation).getNextSunriseOrSunset();

                if (nextSunriseOrSunset != null) {
                    var timeInfo = Time.Gregorian.info(nextSunriseOrSunset, Time.FORMAT_LONG);
                    return formatHoursAndMinutes(timeInfo.hour, timeInfo.min);
                }
            }
        } catch (ex) {
            return EXCEPTION_STRING;
        }

        return DEFAULT_STRING;
    }

    function getNextSunEventColor() as Graphics.ColorType {
        var currentLocation = new ActivityInfoData().getCurrentLocation();

        if (currentLocation != null) {
            var nextSunEventIsSunrise = new SunEvents(currentLocation).isSunrise();
            if (nextSunEventIsSunrise) {
                return Graphics.COLOR_PURPLE;
            }
        }

        return Graphics.COLOR_PINK;
    }

    function update(sunsetOrSunriseLayout as WatchUi.Text) as Void {
        sunsetOrSunriseLayout.setText(getSunsetOrSunriseString());
        sunsetOrSunriseLayout.setColor(getNextSunEventColor());
        sunsetOrSunriseLayout.setLocation(_locX, _locY);
    }
}

