import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class SnowFlake extends WatchUi.Drawable {
    function initialize(options) {
        Drawable.initialize(options);
    }

    function draw(dc as Dc) as Void {
        var sixthCircle = 2*Math.PI/6;
        var mainLineCircleRadius = self.width/2;
        var armCircleRadius = self.width/4;
        var armAngle = Math.PI/8;

        dc.setClip(self.locX-mainLineCircleRadius, self.locY-mainLineCircleRadius, self.width, self.width);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        for (var i = 1; i < 7; i++) {
            var mc = new Circle(mainLineCircleRadius, self.locX, self.locY).getCoordinatesAtAngle(sixthCircle * i);
            dc.drawLine(self.locX, self.locY, mc[0], mc[1]);

            var armStartCoordinates = new Circle(armCircleRadius, self.locX, self.locY).getCoordinatesAtAngle(sixthCircle * i);
            var armOneEndCoordinates = new Circle(mainLineCircleRadius, self.locX, self.locY).getCoordinatesAtAngle(sixthCircle * i + armAngle);
            var armTwoEndCoordinates = new Circle(mainLineCircleRadius, self.locX, self.locY).getCoordinatesAtAngle(sixthCircle * i - armAngle);

            dc.drawLine(armStartCoordinates[0], armStartCoordinates[1], armOneEndCoordinates[0], armOneEndCoordinates[1]);
            dc.drawLine(armStartCoordinates[0], armStartCoordinates[1], armTwoEndCoordinates[0], armTwoEndCoordinates[1]);
        }

        dc.clearClip();
    }
}
