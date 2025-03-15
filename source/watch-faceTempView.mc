import Toybox.Lang;
import Toybox.Graphics;
import Toybox.Weather;
import Toybox.WatchUi;

class TempView {
    typedef Options as {
        :locX as Lang.Number,
        :locY as Lang.Number
    };

    private var _locX as Lang.Number;
    private var _locY as Lang.Number;
    private var _currentTempF as Lang.Number;

    function convertCelciusToFarenheit(celcius as Lang.Number) as Lang.Number {
        return celcius * 9/5 + 32;
    }

    function getCurrentTempF() as Lang.Number or Null {
        var currentConditions = Weather.getCurrentConditions();
        if (currentConditions != null) {
            var currentTempC = currentConditions.temperature;
            if (currentTempC != null) {
                return convertCelciusToFarenheit(currentTempC);
            }
        }

        return null;
    }

    function initialize(options as Options) {
        _currentTempF = getCurrentTempF();
        _locX = options[:locX];
        _locY = options[:locY];
    }

    function getTempString() as String {
        try {
            if (_currentTempF != null) {
                var currentTempString = formatAsZeroPaddedNumber(_currentTempF);

                // adding leading spaces to adjust spacing
                return "  " + currentTempString + "°";
            }
        } catch (ex) {
            return EXCEPTION_STRING;
        }

        return DEFAULT_STRING;
    }

    function getTempColor() as Graphics.ColorType {
        if (_currentTempF == null) {
            return Graphics.COLOR_DK_GRAY;
        } else if (_currentTempF < 10) {
            return Graphics.COLOR_WHITE;
        } else if (_currentTempF < 32) {
            return Graphics.COLOR_BLUE;
        } else if (_currentTempF < 50) {
            return Graphics.COLOR_GREEN;
        } else if (_currentTempF < 70) {
            return Graphics.COLOR_YELLOW;
        } else if (_currentTempF < 80) {
            return Graphics.COLOR_ORANGE;
        } else if (_currentTempF < 90) {
            return Graphics.COLOR_RED;
        } else {
            return Graphics.COLOR_DK_RED;
        }
    }

    function update(tempLayout as WatchUi.Text) as Void {
        tempLayout.setText(getTempString());
        tempLayout.setLocation(_locX, _locY);
        tempLayout.setColor(getTempColor());
    }
}
