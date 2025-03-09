import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
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

    function getCurrentTempF() as Lang.Number or Null {
        var currentConditions = Weather.getCurrentConditions();
        if (currentConditions != null) {
            var currentTempC = currentConditions.temperature;
            if (currentTempC != null) {
                return convertCelciusToFarenheit(currentTempC);
            }
        }

        return null;
    }

    function setTempString(currentTempF as Lang.Number or Null) as Void {
        try {
            if (currentTempF != null) {
                var currentTempString = formatAsZeroPaddedNumber(currentTempF);

                // adding leading spaces to adjust spacing
                tempString = "  " + currentTempString + "°";
            }
        } catch (ex) {
            tempString = EXCEPTION_STRING;
        }
    }

    function getCircleCoordinates(radians as Lang.Number or Lang.Float or Lang.Double, radius as Lang.Number, circleCenterX as Lang.Number, circleCenterY as Lang.Number) as Array<Lang.Number or Lang.Float or Lang.Double> {
        var x = circleCenterX + radius * Math.cos(radians);
        var y = circleCenterY + radius * Math.sin(radians);

        return [x, y];
    }

    function getBeamAngles(numberOfBeams as Lang.Number) as Lang.Array<Lang.Float or Lang.Number> {
        var beamAngles = [] as Lang.Array<Lang.Float or Lang.Number>;
        for (var i = 0; i < 2 * Math.PI; i += Math.PI / (numberOfBeams / 2)) {
            beamAngles.add(i);
        }

        return beamAngles;
    }

    function drawSun(dc as Dc, midX as Lang.Number, midY as Lang.Number) as Void {
        var sunRadius = 8;
        var outerRadius = 18;
        var beamOffset = 3;
        var numberOfBeams = 16;

        dc.setClip(midX - outerRadius, midY - outerRadius, outerRadius * 2 + 1, outerRadius * 2 + 1);

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(midX, midY, sunRadius);

        var beamAngles = getBeamAngles(numberOfBeams);

        for (var i = 0; i < beamAngles.size(); i++) {
            var innerCoordinates = getCircleCoordinates(beamAngles[i], sunRadius + beamOffset, midX, midY);
            var outerCoordinates = getCircleCoordinates(beamAngles[i], outerRadius, midX, midY);

            var innerX = innerCoordinates[0];
            var innerY = innerCoordinates[1];

            var outerX = outerCoordinates[0];
            var outerY = outerCoordinates[1];

            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(innerX, innerY, outerX, outerY);
        }

        dc.clearClip();
    }

    function drawRainDrop(dc as Dc, midX as Lang.Number, midY as Lang.Number) as Void {
        var radius = 5;
        var rainDropLength = 15;

        dc.setClip(midX - radius, midY, (radius * 2) + 1, rainDropLength + 7);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);

        dc.drawLine(midX, midY, midX - radius, midY + rainDropLength);
        dc.drawLine(midX, midY, midX + radius, midY + rainDropLength);
        dc.drawArc(midX, midY + rainDropLength, radius, Graphics.ARC_COUNTER_CLOCKWISE, 180, 0);

        dc.clearClip();
    }

    function drawWind(dc as Dc, midX as Lang.Number, midY as Lang.Number) as Void {
        var windLineLength = 15;
        var windLineGap = 5;
        var arcRadius = 4;

        var lineStartX = midX - windLineLength;
        var offsetLineStartX = midX - windLineLength / 3;

        dc.setClip(lineStartX, midY - windLineGap - arcRadius*2, offsetLineStartX + windLineLength + arcRadius, midY + windLineGap + arcRadius*2);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawLine(lineStartX, midY - windLineGap, lineStartX + windLineLength, midY - windLineGap);
        dc.drawArc(lineStartX + windLineLength, midY - windLineGap - arcRadius, arcRadius, Graphics.ARC_COUNTER_CLOCKWISE, -90, 130);

        dc.drawLine(offsetLineStartX, midY, offsetLineStartX + windLineLength, midY);
        dc.drawArc(offsetLineStartX + windLineLength, midY - arcRadius, arcRadius, Graphics.ARC_COUNTER_CLOCKWISE, -90, 130);

        dc.drawLine(lineStartX, midY + windLineGap, lineStartX + windLineLength, midY + windLineGap);
        dc.drawArc(lineStartX + windLineLength, midY + windLineGap + arcRadius, arcRadius, Graphics.ARC_COUNTER_CLOCKWISE, -130, 90);

        dc.clearClip();
    }

    function drawCloud(dc as Dc, midX as Lang.Number, midY as Lang.Number) as Void {
        var cloudLineLength = 15;
        var arcRadius = 4;

        var lineStartX = midX - cloudLineLength/2;

        dc.setClip(lineStartX-arcRadius, midY - arcRadius*4, cloudLineLength + arcRadius*2+1, arcRadius*4+1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawLine(lineStartX, midY, lineStartX + cloudLineLength, midY);
        dc.drawArc(lineStartX + cloudLineLength, midY - arcRadius, arcRadius, Graphics.ARC_COUNTER_CLOCKWISE, -90, 90);
        dc.drawArc(lineStartX, midY - arcRadius, arcRadius, Graphics.ARC_CLOCKWISE, -90, 90);
        dc.drawArc(lineStartX + arcRadius, midY - arcRadius*2, arcRadius + 1, Graphics.ARC_CLOCKWISE, 180, 0);
        dc.drawArc(lineStartX + arcRadius + arcRadius*2, midY - arcRadius*2, arcRadius * 1.5, Graphics.ARC_CLOCKWISE, 130, -15);

        dc.clearClip();
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

    function getTempColor(tempF as Lang.Number or Null) as Graphics.ColorType {
        if (tempF == null) {
            return Graphics.COLOR_DK_GRAY;
        } else if (tempF < 10) {
            return Graphics.COLOR_WHITE;
        } else if (tempF < 32) {
            return Graphics.COLOR_BLUE;
        } else if (tempF < 50) {
            return Graphics.COLOR_GREEN;
        } else if (tempF < 70) {
            return Graphics.COLOR_YELLOW;
        } else if (tempF < 80) {
            return Graphics.COLOR_ORANGE;
        } else if (tempF < 90) {
            return Graphics.COLOR_RED;
        } else {
            return Graphics.COLOR_DK_RED;
        }
    }

    function updateTempView(locX as Lang.Number, locY as Lang.Number) as Void {
        var currentTempF = getCurrentTempF();
        setTempString(currentTempF);

        var tempView = View.findDrawableById(TEMP_LABEL) as Text;
        tempView.setText(tempString);
        tempView.setLocation(locX, locY);
        tempView.setColor(getTempColor(currentTempF));
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

    function updateSunsetOrSunriseView(locX as Lang.Number, locY as Lang.Number) as Void {
        setSunsetOrSunriseString();

        var sunsetOrSunriseView = View.findDrawableById(SUNSET_OR_SUNRISE_LABEL) as Text;

        sunsetOrSunriseView.setText(sunsetOrSunriseString);
        sunsetOrSunriseView.setColor(getNextSunEventColor());
        sunsetOrSunriseView.setLocation(locX, locY);
    }

    function updateWeatherIcon(dc as Dc, midX as Lang.Number, midY as Lang.Number) as Void {
        var currentConditions = Weather.getCurrentConditions();

        if (currentConditions != null && currentConditions.condition != null) {
            var condition = currentConditions.condition;

            var sunnyConditions = [0, 1, 22, 23, 40];
            var rainyConditions = [3, 6, 11, 12, 13, 14, 15, 24, 25, 26, 31, 41, 42, 49];
            var windyConditions = [5, 32];
            var cloudyConditions = [2, 20];

            if (sunnyConditions.indexOf(condition) != -1) {
                drawSun(dc, midX, midY);
            } else if (rainyConditions.indexOf(condition) != -1) {
                drawRainDrop(dc, midX, midY);
            } else if (windyConditions.indexOf(condition) != -1) {
                drawWind(dc, midX, midY);
            } else if (cloudyConditions.indexOf(condition) != -1) {
                drawCloud(dc, midX, midY);
            }
        }
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

        // Draw custom drawables after calling View.onUpdate(dc);
        updateWeatherIcon(dc, midX, environmentValuesY + 60);
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
