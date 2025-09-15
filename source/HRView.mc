import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class HRView {
    typedef Options as {
        :locX as Lang.Number,
        :locY as Lang.Number
    };

    private var _dc as Graphics.Dc;
    private var _locX as Lang.Number;
    private var _locY as Lang.Number;
    private var _hr as Lang.Number or Null;

    function initialize(options as Options, dc as Graphics.Dc) {
        _dc = dc;
        _locX = options[:locX];
        _locY = options[:locY];
        _hr = new ActivityInfoData().getHR();
    }

    function getHRColor() as Graphics.ColorType {
        if (_hr == null) {
            return Graphics.COLOR_DK_GRAY;
        } else if (_hr < 130) {
            return GREEN;
        } else if (_hr < 170) {
            return YELLOW;
        } else {
            return Graphics.COLOR_RED;
        }
    }

    function update() as Void {
        _dc.setColor(getHRColor(), Graphics.COLOR_BLACK);

        if (_hr != null) {
            _dc.drawText(_locX, _locY, Graphics.FONT_NUMBER_MEDIUM, formatAsZeroPaddedNumber(_hr), Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            _dc.drawText(_locX, _locY, Graphics.FONT_NUMBER_MEDIUM, DEFAULT_STRING, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}
