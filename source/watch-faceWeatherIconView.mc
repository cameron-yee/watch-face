import Toybox.Graphics;
import Toybox.Lang;

class WeatherIconView {
    typedef Options as {
        :midX as Lang.Number,
        :midY as Lang.Number
    };

    private var _midX as Lang.Number;
    private var _midY as Lang.Number;

    function initialize(options as Options) {
        _midX = options[:midX];
        _midY = options[:midY];
    }

    function drawSunOrMoon(dc as Dc, midX as Lang.Number, midY as Lang.Number) as Void {
        var activityInfoData = new ActivityInfoData();
        var currentLocation = activityInfoData.getCurrentLocation();

        if (currentLocation == null) {
            return;
        }

        var nextSunEventIsSunrise = new SunEvents(currentLocation).isSunrise();

        if (nextSunEventIsSunrise) {
            new Moon({
                :midX => midX,
                :midY => midY,
                :outerMoonRadius => 10
            }).draw(dc);
        } else {
            new Sun({
                :midX => midX,
                :midY => midY,
                :sunRadius => 8,
                :outerRadius => 18,
                :beamOffset => 3,
                :numberOfBeams => 16
            }).draw(dc);
        }
    }

    function update(dc as Dc) as Void {
        var currentConditions = Weather.getCurrentConditions();

        if (currentConditions != null && currentConditions.condition != null) {
            var condition = currentConditions.condition;

            var sunnyConditions = [0, 1, 22, 23, 40];
            var rainyConditions = [3, 6, 11, 12, 13, 14, 15, 24, 25, 26, 31, 41, 42, 49];
            var windyConditions = [5, 32];
            var cloudyConditions = [2, 20];
            var snowyConditions = [4, 16, 17, 18, 19, 21, 43, 44, 46, 47, 48, 50, 51];

            if (sunnyConditions.indexOf(condition) != -1) {
                drawSunOrMoon(dc, _midX, _midY);
            } else if (rainyConditions.indexOf(condition) != -1) {
                new RainDrop({
                     :locX => _midX,
                     :locY => _midY,
                     :height => 15,
                     :width => 10
                }).draw(dc);
            } else if (windyConditions.indexOf(condition) != -1) {
                new Wind({
                    :locX => _midX,
                    :locY => _midY,
                    :height => 18,
                    :width => 15
                }).draw(dc);
            } else if (cloudyConditions.indexOf(condition) != -1) {
                new Cloud({
                    :midX => _midX,
                    :midY => _midY,
                    :radius => 4,
                    :cloudLineLength => 15
                }).draw(dc);
            } else if (snowyConditions.indexOf(condition) != -1) {
                new SnowFlake({
                    :midX => _midX,
                    :midY => _midY,
                    :snowLineLength => 30
                }).draw(dc);
            }
        }
    }
}
