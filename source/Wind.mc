import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Wind extends WatchUi.Drawable {
    private var _radius as Lang.Number;
    private var _windLineGap as Lang.Number;
    private var _windLineLength as Lang.Number;

    function initialize(options) {
        Drawable.initialize(options);

        _windLineGap = self.height / 3 - 1;
        _radius = _windLineGap - 1;
        _windLineLength = self.width;
    }

    function draw(dc as Dc) as Void {
        var lineStartX = self.locX - _windLineLength;
        var offsetLineStartX = self.locX - _windLineLength / 3;

        dc.setClip(lineStartX, self.locY - _windLineGap - _radius*2, offsetLineStartX + _windLineLength + _radius, self.locY + _windLineGap + _radius*2);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawLine(lineStartX, self.locY - _windLineGap, lineStartX + _windLineLength, self.locY - _windLineGap);
        dc.drawArc(lineStartX + _windLineLength, self.locY - _windLineGap - _radius, _radius, Graphics.ARC_COUNTER_CLOCKWISE, -90, 130);

        dc.drawLine(offsetLineStartX, self.locY, offsetLineStartX + _windLineLength, self.locY);
        dc.drawArc(offsetLineStartX + _windLineLength, self.locY - _radius, _radius, Graphics.ARC_COUNTER_CLOCKWISE, -90, 130);

        dc.drawLine(lineStartX, self.locY + _windLineGap, lineStartX + _windLineLength, self.locY + _windLineGap);
        dc.drawArc(lineStartX + _windLineLength, self.locY + _windLineGap + _radius, _radius, Graphics.ARC_COUNTER_CLOCKWISE, -130, 90);

        dc.clearClip();
    }
}

