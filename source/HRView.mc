import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class HRView {
    typedef Options as {
        :locX as Lang.Number,
        :locY as Lang.Number
    };

    private var _locX as Lang.Number;
    private var _locY as Lang.Number;
    private var _hr as Lang.Number or Null;

    function initialize(options as Options) {
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

    function update(hrLayout as WatchUi.Text) as Void {
        if (_hr != null) {
            hrLayout.setText(formatAsZeroPaddedNumber(_hr));
        } else {
            hrLayout.setText(DEFAULT_STRING);
        }

        hrLayout.setLocation(_locX, _locY);
        hrLayout.setColor(getHRColor());
    }
}
