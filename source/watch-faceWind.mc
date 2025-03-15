import Toybox.Graphics;
import Toybox.Lang;

class Wind {
    typedef Options as {
        :midX as Lang.Number,
        :midY as Lang.Number,
        :radius as Lang.Number,
        :windLineLength as Lang.Number,
        :windLineGap as Lang.Number
    };

    private var _midX as Lang.Number;
    private var _midY as Lang.Number;
    private var _radius as Lang.Number;
    private var _windLineGap as Lang.Number;
    private var _windLineLength as Lang.Number;

    function initialize(options as Options) {
        _midX = options[:midX];
        _midY = options[:midY];
        _radius = options[:radius];
        _windLineGap = options[:windLineGap];
        _windLineLength = options[:windLineLength];
    }

    function draw(dc as Dc) as Void {
        var lineStartX = _midX - _windLineLength;
        var offsetLineStartX = _midX - _windLineLength / 3;

        dc.setClip(lineStartX, _midY - _windLineGap - _radius*2, offsetLineStartX + _windLineLength + _radius, _midY + _windLineGap + _radius*2);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawLine(lineStartX, _midY - _windLineGap, lineStartX + _windLineLength, _midY - _windLineGap);
        dc.drawArc(lineStartX + _windLineLength, _midY - _windLineGap - _radius, _radius, Graphics.ARC_COUNTER_CLOCKWISE, -90, 130);

        dc.drawLine(offsetLineStartX, _midY, offsetLineStartX + _windLineLength, _midY);
        dc.drawArc(offsetLineStartX + _windLineLength, _midY - _radius, _radius, Graphics.ARC_COUNTER_CLOCKWISE, -90, 130);

        dc.drawLine(lineStartX, _midY + _windLineGap, lineStartX + _windLineLength, _midY + _windLineGap);
        dc.drawArc(lineStartX + _windLineLength, _midY + _windLineGap + _radius, _radius, Graphics.ARC_COUNTER_CLOCKWISE, -130, 90);

        dc.clearClip();
    }
}

