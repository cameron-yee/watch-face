import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.WatchUi;

class Moon extends WatchUi.Drawable {
    typedef MoonOptions as {
        :outerMoonRadius as Lang.Number
    };

    private var _outerMoonRadius as Lang.Number;
    private var _moonPointCoordinatesAngle = 4*Math.PI/3;

    function initialize(drawableOptions, moonOptions as MoonOptions) {
        Drawable.initialize(drawableOptions);
        _outerMoonRadius = moonOptions[:outerMoonRadius];
    }

    function draw(dc as Dc) as Void {
        var moonPointCoordinates = new Circle(_outerMoonRadius, self.locX, self.locY).getCoordinatesAtAngle(_moonPointCoordinatesAngle);
        var innerMoonRadius = self.locY - moonPointCoordinates[1];

        var moonPointX = moonPointCoordinates[0];

        dc.setClip(self.locX - _outerMoonRadius, self.locY - _outerMoonRadius, _outerMoonRadius * 2 + 1, _outerMoonRadius * 2 + 1);
        dc.setColor(YELLOW, Graphics.COLOR_TRANSPARENT);

        dc.drawArc(self.locX, self.locY, _outerMoonRadius, Graphics.ARC_CLOCKWISE, 120, 240);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(moonPointX, self.locY, innerMoonRadius, Graphics.ARC_CLOCKWISE, 90, -90);

        dc.clearClip();
    }
}
