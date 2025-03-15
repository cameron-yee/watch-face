import Toybox.Lang;
import Toybox.Position;
import Toybox.Time;

class SunEvents {
    private var _currentLocation;

    function initialize(currentLocation as Position.Location) {
        _currentLocation = currentLocation;
    }

    function getSunEvents() as Array<Time.Moment or Null> {
        var now = Time.now();
        var oneDay = new Time.Duration(Gregorian.SECONDS_PER_DAY);
        var tomorrow = now.add(oneDay);

        var todaysSunrise = Weather.getSunrise(_currentLocation, now);
        var todaysSunset = Weather.getSunset(_currentLocation, now);
        var tomorrowsSunrise = Weather.getSunrise(_currentLocation, tomorrow);

        return [todaysSunrise, todaysSunset, tomorrowsSunrise];
    }

    function isPastTodaysSunrise() as Lang.Boolean {
        var sunEvents = getSunEvents();

        var todaysSunrise = sunEvents[0];
        var todaysSunset = sunEvents[1];

        return todaysSunset.compare(todaysSunrise) > 0;
    }

    function isPastTodaysSunset() as Lang.Boolean {
        var sunEvents = getSunEvents();
        var todaysSunset = sunEvents[1];
        var now = Time.now();

        return now.compare(todaysSunset) > 0;
    }

    function isSunrise() as Lang.Boolean {
        var pastSunrise = isPastTodaysSunrise();
        var pastSunset = isPastTodaysSunset();

        return (pastSunrise && pastSunset) || !pastSunrise
          ? true
          : false;
    }

    function getNextSunriseOrSunset() as Time.Moment or Null {
        var sunEvents = getSunEvents();
        var pastSunrise = isPastTodaysSunrise();
        var pastSunset = isPastTodaysSunset();

        return pastSunrise && pastSunset
          ? sunEvents[2]
          : pastSunrise
            ? sunEvents[1]
            : sunEvents[0];
    }
}
