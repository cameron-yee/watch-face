
import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class ErrorView {
    typedef Options as {
        :locX as Lang.Number,
        :locY as Lang.Number
    };

    private var _locX as Lang.Number;
    private var _locY as Lang.Number;

    function initialize(options as Options, dc as Graphics.Dc) {
        _locX = options[:locX];
        _locY = options[:locY];
    }

    function update(layout as WatchUi.Text) as Void {
        layout.setFont(Graphics.FONT_SYSTEM_XTINY);
        layout.setText("ERROR");
        layout.setLocation(_locX, _locY);
        layout.setColor(GRAY);
    }
}
