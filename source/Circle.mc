import Toybox.Lang;
import Toybox.Math;

class Circle {
    private var _radius;
    private var _centerX;
    private var _centerY;

    function initialize(
        radius as Lang.Number,
        centerX as Lang.Number,
        centerY as Lang.Number
    ) {
        _radius = radius;
        _centerX = centerX;
        _centerY = centerY;
    }

    function getCoordinatesAtAngle(radians as Lang.Number or Lang.Float or Lang.Double) as Lang.Array<Lang.Number or Lang.Float or Lang.Double> {
        var x = _centerX + _radius * Math.cos(radians);
        var y = _centerY + _radius * Math.sin(radians);

        return [x, y];
    }
}
