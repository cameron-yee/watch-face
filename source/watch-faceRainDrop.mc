import Toybox.Graphics;
import Toybox.Lang;

class RainDrop {
    typedef Options as {
        :midX as Lang.Number,
        :midY as Lang.Number,
        :radius as Lang.Number,
        :rainDropLength as Lang.Number
    };

    private var _midX as Lang.Number;
    private var _midY as Lang.Number;
    private var _radius as Lang.Number;
    private var _rainDropLength as Lang.Number;

    function initialize(options as Options) {
        _midX = options[:midX];
        _midY = options[:midY];
        _radius = options[:radius];
        _rainDropLength = options[:rainDropLength];
    }

    function draw(dc as Graphics.Dc) as Void {
        dc.setClip(_midX - _radius, _midY, (_radius * 2) + 1, _rainDropLength + 7);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);

        dc.drawLine(_midX, _midY, _midX - _radius, _midY + _rainDropLength);
        dc.drawLine(_midX, _midY, _midX + _radius, _midY + _rainDropLength);
        dc.drawArc(_midX, _midY + _rainDropLength, _radius, Graphics.ARC_COUNTER_CLOCKWISE, 180, 0);

        dc.clearClip();
    }
}
