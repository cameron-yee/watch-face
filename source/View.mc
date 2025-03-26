import Toybox.Graphics;
import Toybox.Math;
import Toybox.WatchUi;

class View extends WatchUi.WatchFace {
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        var midX = screenWidth/2;
        var midY = screenHeight/2;
        var sixthY = screenHeight/6;
        var environmentValuesY = midY + sixthY;

        try {
            var watchFacePerimeter = new Circle(environmentValuesY + 60 - midY, midX, midY);

            var tempLayout = WatchUi.View.findDrawableById(TEMP_LABEL) as WatchUi.Text;
            var tempLoc = watchFacePerimeter.getCoordinatesAtAngle(Math.PI/4.5);
            new TempView({
                 :locX => tempLoc[0],
                 :locY => tempLoc[1]
            }).update(tempLayout);

            var hourLayout = WatchUi.View.findDrawableById(HOUR_LABEL) as WatchUi.Text;
            var minutesLayout = WatchUi.View.findDrawableById(MINUTES_LABEL) as WatchUi.Text;
            var dateLayout = WatchUi.View.findDrawableById(DATE_LABEL) as WatchUi.Text;
            new TimeView({
                :locX => midX,
                :locY => midY
            }, dc).update(hourLayout, minutesLayout, dateLayout);

            var hrLayout = WatchUi.View.findDrawableById(HR_LABEL) as WatchUi.Text;
            var hrLoc = watchFacePerimeter.getCoordinatesAtAngle(3*Math.PI/2);
            new HRView({
                :locX => hrLoc[0],
                :locY => hrLoc[1] - dc.getFontHeight(Graphics.FONT_NUMBER_MEDIUM)/2
            }).update(hrLayout);

            var sunsetOrSunriseHourLayout = WatchUi.View.findDrawableById(SUNSET_OR_SUNRISE_HOUR_LABEL) as WatchUi.Text;
            var sunsetOrSunriseMinutesLayout = WatchUi.View.findDrawableById(SUNSET_OR_SUNRISE_MINUTES_LABEL) as WatchUi.Text;
            var sunsetOrSunriseLoc = watchFacePerimeter.getCoordinatesAtAngle(3.5*Math.PI/4.5);

            new SunsetOrSunriseView({
                :locX => sunsetOrSunriseLoc[0],
                :locY => sunsetOrSunriseLoc[1]
            }, dc).update(sunsetOrSunriseHourLayout, sunsetOrSunriseMinutesLayout);
        } catch (ex) {}

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        // Draw custom drawables after calling View.onUpdate(dc);
        new WeatherIconView({
            :midX => midX,
            :midY => environmentValuesY + 60
        }).update(dc);
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
