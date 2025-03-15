import Toybox.Graphics;
import Toybox.Lang;

class Sun {
    typedef Options as {
        :midX as Lang.Number,
        :midY as Lang.Number,
        :sunRadius as Lang.Number,
        :outerRadius as Lang.Number,
        :beamOffset as Lang.Number,
        :numberOfBeams as Lang.Number
    };

    private var _midX as Lang.Number;
    private var _midY as Lang.Number;
    private var _sunRadius as Lang.Number;
    private var _outerRadius as Lang.Number;
    private var _beamOffset as Lang.Number;
    private var _numberOfBeams as Lang.Number;

    private var _beamAngles;

    function getBeamAngles(numberOfBeams as Lang.Number) as Lang.Array<Lang.Float or Lang.Number> {
        var beamAngles = [] as Lang.Array<Lang.Float or Lang.Number>;
        for (var i = 0; i < 2 * Math.PI; i += Math.PI / (numberOfBeams / 2)) {
            beamAngles.add(i);
        }

        return beamAngles;
    }

    function initialize(options as Options) {
        _midX = options[:midX];
        _midY = options[:midY];
        _sunRadius = options[:sunRadius];
        _outerRadius = options[:outerRadius];
        _beamOffset = options[:beamOffset];
        _numberOfBeams = options[:numberOfBeams];
        _beamAngles = getBeamAngles(_numberOfBeams);
    }

    function draw(dc as Graphics.Dc) as Void {
        dc.setClip(_midX - _outerRadius, _midY - _outerRadius, _outerRadius * 2 + 1, _outerRadius * 2 + 1);

        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(_midX, _midY, _sunRadius);

        for (var i = 0; i < _beamAngles.size(); i++) {
            var innerCoordinates = new Circle(_sunRadius + _beamOffset, _midX, _midY).getCoordinatesAtAngle(_beamAngles[i]);
            var outerCoordinates = new Circle(_outerRadius, _midX, _midY).getCoordinatesAtAngle(_beamAngles[i]);

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


