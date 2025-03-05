import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;
import Toybox.Weather;
import Toybox.Position;
import Toybox.Application;

class watch_faceView extends WatchUi.WatchFace {
    var DEFAULT_STRING = "--";
    var EXCEPTION_STRING = "**";

    var TEMP_LABEL = "TempLabel";
    var HR_LABEL = "HRLabel";
    var TIME_LABEL = "TimeLabel";
    var SUNSET_OR_SUNRISE_LABEL = "SunsetOrSunriseLabel";

    var sunsetOrSunriseString = DEFAULT_STRING;
    var hrString = DEFAULT_STRING;
    var tempString = DEFAULT_STRING;
    var timeString = DEFAULT_STRING;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function formatAs12Hour(hour as Lang.Number) as Lang.Number {
        return hour < 13
          ? hour
          : hour % 12;
    }

    function formatAsZeroPaddedNumber(num as Lang.Number) as Lang.String {
        return num.format("%02d");
    }

    function formatHoursAndMinutes(hour as Lang.Number, min as Lang.Number) as Lang.String {
        return Lang.format(
            "$1$:$2$",
            [
                formatAs12Hour(hour),
                formatAsZeroPaddedNumber(min)
            ]
        );
    }

    function setTimeString() as Void {
        try {
            var clockTime = System.getClockTime();
            timeString = formatHoursAndMinutes(clockTime.hour, clockTime.min);
        } catch (ex) {
            timeString = EXCEPTION_STRING;
        }
    }

    function getCurrentLocation() as Position.Location or Null {
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null && activityInfo.currentLocation != null) {
            return activityInfo.currentLocation;
        }

        var coordinates = Application.Storage.getValue("coordinates") as Lang.Array<Lang.Number>;
        if (coordinates == null) {
            return null;
        }
        var latitude = coordinates[0] as Lang.Number;
        var longitude = coordinates[1] as Lang.Number;
        return new Position.Location(
            {
                :latitude => latitude,
                :longitude => longitude,
                :format => :degrees
            }
        );
    }

    function getSunEvents(currentLocation as Position.Location) as Array<Time.Moment or Null> {
        var now = Time.now();
        var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
        var tomorrow = now.add(oneDay);

        var todaysSunrise = Weather.getSunrise(currentLocation, now);
        var todaysSunset = Weather.getSunset(currentLocation, now);
        var tomorrowsSunrise = Weather.getSunrise(currentLocation, tomorrow);

        return [todaysSunrise, todaysSunset, tomorrowsSunrise];
    }

    function isPastTodaysSunrise(currentLocation as Position.Location) as Lang.Boolean {
        var sunEvents = getSunEvents(currentLocation);

        var todaysSunrise = sunEvents[0];
        var todaysSunset = sunEvents[1];

        return todaysSunset.compare(todaysSunrise) > 0;
    }

    function isPastTodaysSunset(currentLocation as Position.Location) as Lang.Boolean {
        var sunEvents = getSunEvents(currentLocation);
        var todaysSunset = sunEvents[1];
        var now = Time.now();

        return now.compare(todaysSunset) > 0;
    }

    function isSunrise(currentLocation as Position.Location) as Lang.Boolean {
        var pastSunrise = isPastTodaysSunrise(currentLocation as Position.Location);
        var pastSunset = isPastTodaysSunset(currentLocation as Position.Location);

        return (pastSunrise && pastSunset) || !pastSunrise
          ? true
          : false;
    }

    function getNextSunriseOrSunset(currentLocation as Position.Location) as Time.Moment or Null {
        var sunEvents = getSunEvents(currentLocation);
        var pastSunrise = isPastTodaysSunrise(currentLocation);
        var pastSunset = isPastTodaysSunset(currentLocation);

        return pastSunrise && pastSunset
          ? sunEvents[2]
          : pastSunrise
            ? sunEvents[1]
            : sunEvents[0];
    }

    function setSunsetOrSunriseString() as Void {
        try {
            var currentLocation = getCurrentLocation();

            if (currentLocation != null) {
                var nextSunriseOrSunset = getNextSunriseOrSunset(currentLocation);

                if (nextSunriseOrSunset != null) {
                    var timeInfo = Time.Gregorian.info(nextSunriseOrSunset, Time.FORMAT_LONG);
                    sunsetOrSunriseString = formatHoursAndMinutes(timeInfo.hour, timeInfo.min);

                    Application.Storage.setValue("coordinates", currentLocation.toDegrees());
                }
            }
        } catch (ex) {
            sunsetOrSunriseString = EXCEPTION_STRING;
        }
    }

    function getHR() as Lang.Number or Null {
        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null && activityInfo.currentHeartRate != null) {
            return activityInfo.currentHeartRate;
        }

        return null;
    }

    function setHRString(hr as Lang.Number or Null) as Void {
        try {
            if (hr != null) {
                hrString = formatAsZeroPaddedNumber(hr);
            }
        } catch (ex) {
            hrString = EXCEPTION_STRING;
        }
    }

    function convertCelciusToFarenheit(celcius as Lang.Number) as Lang.Number {
        return celcius * 9/5 + 32;
    }

    function setTempString() as Void {
        try {
            var currentConditions = Weather.getCurrentConditions();
            if (currentConditions != null) {
                var currentTempC = currentConditions.temperature;
                if (currentTempC != null) {
                    var currentTempF = convertCelciusToFarenheit(currentTempC);
                    var currentTempString = formatAsZeroPaddedNumber(currentTempF);

                    // adding leading spaces to adjust spacing
                    tempString = "  " + currentTempString + "°";
                }
            }
        } catch (ex) {
            tempString = EXCEPTION_STRING;
        }
    }

    function getHRColor(hr as Lang.Number or Null) as Graphics.ColorType {
        if (hr == null) {
            return Graphics.COLOR_DK_GRAY;
        } else if (hr < 130) {
            return Graphics.COLOR_GREEN;
        } else if (hr < 170) {
            return Graphics.COLOR_ORANGE;
        } else {
            return Graphics.COLOR_RED;
        }
    }

    function updateTempView(locX as Lang.Number, locY as Lang.Number) as Void {
        setTempString();

        var tempView = View.findDrawableById(TEMP_LABEL) as Text;
        tempView.setText(tempString);
        tempView.setLocation(locX, locY);
    }

    function updateTimeView(locX as Lang.Number, locY as Lang.Number) as Void {
        setTimeString();

        var timeView = View.findDrawableById(TIME_LABEL) as Text;
        timeView.setLocation(locX, locY);
        timeView.setText(timeString);
    }

    function updateHRView(locX as Lang.Number, locY as Lang.Number) as Void {
        var hr = getHR();
        setHRString(hr);

        var hrView = View.findDrawableById(HR_LABEL) as Text;
        hrView.setText(hrString);
        hrView.setLocation(locX, locY);
        hrView.setColor(getHRColor(hr));
    }

    function getNextSunEventColor() as Graphics.ColorType {
        var currentLocation = getCurrentLocation();
        if (currentLocation != null) {
            var nextSunEventIsSunrise = isSunrise(currentLocation);
            if (nextSunEventIsSunrise) {
                return Graphics.COLOR_PURPLE;
            }
        }

        return Graphics.COLOR_PINK;
    }

    function updateSunsetOrSunriseView(locX as Lang.Number, locY as Lang.Number) as Void {
        setSunsetOrSunriseString();

        var sunsetOrSunriseView = View.findDrawableById(SUNSET_OR_SUNRISE_LABEL) as Text;

        sunsetOrSunriseView.setText(sunsetOrSunriseString);
        sunsetOrSunriseView.setColor(getNextSunEventColor());
        sunsetOrSunriseView.setLocation(locX, locY);
    }

    function onUpdate(dc as Dc) as Void {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        var midX = screenWidth/2;
        var quarterX = screenWidth/4;
        var midY = screenHeight/2;
        var sixthY = screenHeight/6;
        var environmentValuesY = midY + sixthY;

        try {
            updateTempView(midX + quarterX, environmentValuesY);
            updateTimeView(WatchUi.LAYOUT_VALIGN_CENTER, WatchUi.LAYOUT_VALIGN_CENTER);
            updateHRView(WatchUi.LAYOUT_VALIGN_CENTER, WatchUi.LAYOUT_VALIGN_TOP);
            updateSunsetOrSunriseView(midX - quarterX, environmentValuesY);
        } catch (ex) {}

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
}
