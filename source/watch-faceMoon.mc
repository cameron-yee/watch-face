import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

class Moon {
    typedef Options as {
        :midX as Lang.Number,
        :midY as Lang.Number,
        :outerMoonRadius as Lang.Number
    };

    private var _midX as Lang.Number;
    private var _midY as Lang.Number;
    private var _outerMoonRadius as Lang.Number;

    private var _moonPointCoordinatesAngle = 4*Math.PI/3;

    function initialize(options as Options) {
        _midX = options[:midX];
        _midY = options[:midY];
        _outerMoonRadius = options[:outerMoonRadius];
    }

    function draw(dc as Dc) as Void {
        var moonPointCoordinates = new Circle(_outerMoonRadius, _midX, _midY).getCoordinatesAtAngle(_moonPointCoordinatesAngle);
        var innerMoonRadius = _midY - moonPointCoordinates[1];

        var moonPointX = moonPointCoordinates[0];

        dc.setClip(moonPointX, _midY - _outerMoonRadius, _midX - moonPointX + _outerMoonRadius+1, _outerMoonRadius*2+1);
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);

        dc.drawArc(_midX, _midY, _outerMoonRadius, Graphics.ARC_CLOCKWISE, 120, 240);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(moonPointX, _midY, innerMoonRadius, Graphics.ARC_CLOCKWISE, 90, -90);

        dc.clearClip();
    }
}
