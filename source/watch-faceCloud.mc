import Toybox.Graphics;
import Toybox.Lang;

class Cloud {
    typedef Options as {
        :midX as Lang.Number,
        :midY as Lang.Number,
        :cloudLineLength as Lang.Number,
        :radius as Lang.Number
    };

    private var _midX as Lang.Number;
    private var _midY as Lang.Number;
    private var _cloudLineLength as Lang.Number;
    private var _radius as Lang.Number;

    function initialize(options as Options) {
        _midX = options[:midX];
        _midY = options[:midY];
        _cloudLineLength  = options[:cloudLineLength];
        _radius  = options[:radius];
    }

    function draw(dc as Dc) as Void {
        var lineStartX = _midX - _cloudLineLength/2;

        dc.setClip(lineStartX-_radius, _midY - _radius*4, _cloudLineLength + _radius*2+1, _radius*4+1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawLine(lineStartX, _midY, lineStartX + _cloudLineLength, _midY);
        dc.drawArc(lineStartX + _cloudLineLength, _midY - _radius, _radius, Graphics.ARC_COUNTER_CLOCKWISE, -90, 90);
        dc.drawArc(lineStartX, _midY - _radius, _radius, Graphics.ARC_CLOCKWISE, -90, 90);
        dc.drawArc(lineStartX + _radius, _midY - _radius*2, _radius + 1, Graphics.ARC_CLOCKWISE, 180, 0);
        dc.drawArc(lineStartX + _radius + _radius*2, _midY - _radius*2, _radius * 1.5, Graphics.ARC_CLOCKWISE, 130, -15);

        dc.clearClip();
    }
}
