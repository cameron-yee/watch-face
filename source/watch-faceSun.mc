import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Sun extends WatchUi.Drawable {
    typedef SunOptions as {
        :sunRadius as Lang.Number,
        :outerRadius as Lang.Number,
        :beamOffset as Lang.Number,
        :numberOfBeams as Lang.Number
    };

    private var _sunRadius as Lang.Number;
    private var _outerRadius as Lang.Number;
    private var _beamOffset as Lang.Number;
    private var _numberOfBeams as Lang.Number;

    private var _beamAngles;

    function getBeamAngles() as Lang.Array<Lang.Float or Lang.Number> {
        var beamAngles = [] as Lang.Array<Lang.Float or Lang.Number>;
        for (var i = 0; i < 2 * Math.PI; i += Math.PI / (_numberOfBeams / 2)) {
            beamAngles.add(i);
        }

        return beamAngles;
    }

    function initialize(drawableOptions, sunOptions as SunOptions) {
        Drawable.initialize(drawableOptions);

        _sunRadius = sunOptions[:sunRadius];
        _outerRadius = sunOptions[:outerRadius];
        _beamOffset = sunOptions[:beamOffset];
        _numberOfBeams = sunOptions[:numberOfBeams];
        _beamAngles = getBeamAngles();
    }

    function draw(dc as Graphics.Dc) as Void {
        dc.setClip(self.locX - _outerRadius, self.locY - _outerRadius, _outerRadius * 2 + 1, _outerRadius * 2 + 1);

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(self.locX, self.locY, _sunRadius);

        for (var i = 0; i < _beamAngles.size(); i++) {
            var innerCoordinates = new Circle(_sunRadius + _beamOffset, self.locX, self.locY).getCoordinatesAtAngle(_beamAngles[i]);
            var outerCoordinates = new Circle(_outerRadius, self.locX, self.locY).getCoordinatesAtAngle(_beamAngles[i]);

            var innerX = innerCoordinates[0];
            var innerY = innerCoordinates[1];

            var outerX = outerCoordinates[0];
            var outerY = outerCoordinates[1];

            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
            dc.drawLine(innerX, innerY, outerX, outerY);
        }

        dc.clearClip();
    }
}


