import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

class View extends WatchUi.View {
    private var _action;

    public function initialize() {
        View.initialize();
        _action = "None";
    }

    public function onUpdate(dc as Dc) as Void {
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        var midX = screenWidth/2;
        var midY = screenHeight/2;
        var sixthY = screenHeight/6;
        var environmentValuesY = midY + sixthY;

        var watchFacePerimeter = new Circle(environmentValuesY + 60 - midY, midX, midY);

        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        if (_action.equals("TAP")) {
            var altitude = new ActivityInfoData().getAltitude();
            if (System.getDeviceSettings().elevationUnits != System.UNIT_METRIC) {
                altitude = altitude * 3.28084;
            }
            var altitudeText = altitude == null ? DEFAULT_STRING : altitude.format("%.2f");

            dc.setColor(YELLOW, Graphics.COLOR_BLACK);
            // dc.drawText(midX, midY - dc.getFontHeight(Graphics.FONT_NUMBER_MEDIUM) + Graphics.getFontDescent(Graphics.FONT_NUMBER_MEDIUM) - 5, Graphics.FONT_NUMBER_MEDIUM, altitudeText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(midX, midY - dc.getFontHeight(Graphics.FONT_NUMBER_MEDIUM)/2 - Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY)/1.5, Graphics.FONT_NUMBER_MEDIUM, altitudeText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(GRAY, Graphics.COLOR_BLACK);
            //dc.drawText(midX, midY, Graphics.FONT_SYSTEM_XTINY, "ALTITUDE", Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(midX, midY + Graphics.getFontHeight(Graphics.FONT_SYSTEM_XTINY)/1.5, Graphics.FONT_SYSTEM_XTINY, "ALTITUDE", Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            var tempLoc = watchFacePerimeter.getCoordinatesAtAngle(Math.PI/4.5);
            new TempView({
                 :locX => tempLoc[0],
                 :locY => tempLoc[1]
            }, dc).update();

            new TimeView({
                :locX => midX,
                :locY => midY
            }, dc).update();

            var hrLoc = watchFacePerimeter.getCoordinatesAtAngle(3*Math.PI/2);
            new HRView({
                :locX => hrLoc[0],
                :locY => hrLoc[1] - dc.getFontHeight(Graphics.FONT_NUMBER_MEDIUM)/2
            }, dc).update();

            var sunsetOrSunriseLoc = watchFacePerimeter.getCoordinatesAtAngle(3.5*Math.PI/4.5);

            new SunsetOrSunriseView({
                :locX => sunsetOrSunriseLoc[0],
                :locY => sunsetOrSunriseLoc[1]
            }, dc).update();

            new WeatherIconView({
                :midX => midX,
                :midY => environmentValuesY + 60
             }).update(dc);
        }
    }

    public function setAction(action) as Void {
        _action = action;
        WatchUi.requestUpdate();
    }
}
