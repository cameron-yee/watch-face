import Toybox.Graphics;
import Toybox.Lang;

class SnowFlake {
    typedef Options as {
        :midX as Lang.Number,
        :midY as Lang.Number,
        :snowLineLength as Lang.Number,
    };

    private var _midX as Lang.Number;
    private var _midY as Lang.Number;
    private var _snowLineLength as Lang.Number;

    function initialize(options as Options) {
        _midX = options[:midX];
        _midY = options[:midY];
        _snowLineLength = options[:snowLineLength];
    }

    function draw(dc as Dc) as Void {
        var sixthCircle = 2*Math.PI/6;
        var mainLineCircleRadius = _snowLineLength/2;
        var armCircleRadius = _snowLineLength/4;
        var armAngle = Math.PI/8;

        dc.setClip(_midX-mainLineCircleRadius,_midY-mainLineCircleRadius,_snowLineLength,_snowLineLength);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        for (var i = 1; i < 7; i++) {
            var mc = new Circle(mainLineCircleRadius, _midX, _midY).getCoordinatesAtAngle(sixthCircle * i);
            dc.drawLine(_midX, _midY, mc[0], mc[1]);

            var armStartCoordinates = new Circle(armCircleRadius, _midX, _midY).getCoordinatesAtAngle(sixthCircle * i);
            var armOneEndCoordinates = new Circle(mainLineCircleRadius, _midX, _midY).getCoordinatesAtAngle(sixthCircle * i + armAngle);
            var armTwoEndCoordinates = new Circle(mainLineCircleRadius, _midX, _midY).getCoordinatesAtAngle(sixthCircle * i - armAngle);

            dc.drawLine(armStartCoordinates[0], armStartCoordinates[1], armOneEndCoordinates[0], armOneEndCoordinates[1]);
            dc.drawLine(armStartCoordinates[0], armStartCoordinates[1], armTwoEndCoordinates[0], armTwoEndCoordinates[1]);
        }

        dc.clearClip();
    }
}
