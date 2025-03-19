import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class RainDrop extends WatchUi.Drawable {
    function initialize(options) {
        Drawable.initialize(options);
        Drawable.setSize(self.width, self.width*1.5);
    }

    function draw(dc as Graphics.Dc) as Void {
        var _radius = self.width / 2;
        dc.setClip(self.locX - _radius, self.locY, (_radius * 2) + 1, self.height + _radius + 1);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);

        dc.drawLine(self.locX, self.locY, self.locX - _radius, self.locY + self.height - _radius);
        dc.drawLine(self.locX, self.locY, self.locX + _radius, self.locY + self.height - _radius);
        dc.drawArc(self.locX, self.locY + self.height - _radius, _radius, Graphics.ARC_COUNTER_CLOCKWISE, 180, 0);

        dc.clearClip();
    }
}
