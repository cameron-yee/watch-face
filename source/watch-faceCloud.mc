import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Cloud extends WatchUi.Drawable {
    private var _radius as Lang.Number;

    function initialize(options) {
        Drawable.initialize(options);

        _radius  = self.width / 3 - 1;
    }

    function draw(dc as Dc) as Void {
        var lineStartX = self.locX - self.width/2;

        dc.setClip(lineStartX-_radius, self.locY - _radius*4, self.width + _radius*2+1, _radius*4+1);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        dc.drawLine(lineStartX, self.locY, lineStartX + self.width, self.locY);
        dc.drawArc(lineStartX + self.width, self.locY - _radius, _radius, Graphics.ARC_COUNTER_CLOCKWISE, -90, 90);
        dc.drawArc(lineStartX, self.locY - _radius, _radius, Graphics.ARC_CLOCKWISE, -90, 90);
        dc.drawArc(lineStartX + _radius, self.locY - _radius*2, _radius + 1, Graphics.ARC_CLOCKWISE, 180, 0);
        dc.drawArc(lineStartX + _radius + _radius*2, self.locY - _radius*2, _radius * 1.5, Graphics.ARC_CLOCKWISE, 130, -15);

        dc.clearClip();
    }
}
