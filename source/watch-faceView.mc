import Toybox.Graphics;
import Toybox.WatchUi;

class watch_faceView extends WatchUi.WatchFace {
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
        var quarterX = screenWidth/4;
        var midY = screenHeight/2;
        var sixthY = screenHeight/6;
        var environmentValuesY = midY + sixthY;

        try {
            var tempLayout = WatchUi.View.findDrawableById(TEMP_LABEL) as WatchUi.Text;
            new TempView({
                 :locX => midX + quarterX,
                 :locY => environmentValuesY
            }).update(tempLayout);

            var timeLayout = WatchUi.View.findDrawableById(TIME_LABEL) as WatchUi.Text;
            new TimeView({
                :locX => WatchUi.LAYOUT_VALIGN_CENTER,
                :locY => WatchUi.LAYOUT_VALIGN_CENTER
            }).update(timeLayout);

            var hrLayout = WatchUi.View.findDrawableById(HR_LABEL) as WatchUi.Text;
            new HRView({
                :locX => WatchUi.LAYOUT_VALIGN_CENTER,
                :locY => WatchUi.LAYOUT_VALIGN_TOP
            }).update(hrLayout);

            var sunsetOrSunriseLayout = WatchUi.View.findDrawableById(SUNSET_OR_SUNRISE_LABEL) as WatchUi.Text;
            new SunsetOrSunriseView({
                :locX => midX - quarterX,
                :locY => environmentValuesY
            }).update(sunsetOrSunriseLayout);
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
