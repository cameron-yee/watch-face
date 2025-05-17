import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Weather;
import Toybox.WatchUi;

class TempView {
    typedef Options as {
        :locX as Lang.Number,
        :locY as Lang.Number
    };

    private var _locX as Lang.Number;
    private var _locY as Lang.Number;
    private var _currentTemp as Lang.Number;
    private var _useCelcius as Lang.Boolean;

    function convertCelciusToFarenheit(celcius as Lang.Number) as Lang.Number {
        return celcius * 9/5 + 32;
    }

    function getCurrentTempC() as Lang.Number or Null {
        var currentConditions = Weather.getCurrentConditions();
        if (currentConditions != null) {
            var currentTempC = currentConditions.temperature;
            if (currentTempC != null) {
                return currentTempC;
            }
        }

        return null;
    }

    function getCurrentTempF() as Lang.Number or Null {
        return convertCelciusToFarenheit(getCurrentTempC());
    }

    function getCurrentTemp() as Lang.Number or Null {
        return _useCelcius
          ? getCurrentTempC()
          : getCurrentTempF();
    }

    function initialize(options as Options) {
        _locX = options[:locX];
        _locY = options[:locY];
        _useCelcius = System.getDeviceSettings().temperatureUnits == System.UNIT_METRIC;
        _currentTemp = getCurrentTemp();
    }

    function getTempString() as String {
        try {
            if (_currentTemp != null) {
                var currentTempString = formatAsZeroPaddedNumber(_currentTemp);

                return currentTempString + "°";
            }
        } catch (ex) {
            return EXCEPTION_STRING;
        }

        return DEFAULT_STRING;
    }

    function getTempColor() as Graphics.ColorType {
        var temperatureColorMap = [
            [-12, Graphics.COLOR_DK_GRAY],
            [0, Graphics.COLOR_WHITE],
            [10, GREEN],
            [21, YELLOW],
            [27, Graphics.COLOR_ORANGE],
            [32, Graphics.COLOR_RED],
        ];

        if (_currentTemp == null) {
            return Graphics.COLOR_DK_GRAY;
        }

        for (var i = 0; i < temperatureColorMap.size(); i++) {
            var tempSetting = temperatureColorMap[i];
            for (var j = 0; j < tempSetting.size(); j++) {
                var temp = _useCelcius ? tempSetting[0] : convertCelciusToFarenheit(tempSetting[0]);
                var color = tempSetting[1];

                if (_currentTemp < temp) {
                    return color;
                }
            }
        }

        return Graphics.COLOR_DK_RED;
    }

    function update(tempLayout as WatchUi.Text) as Void {
        tempLayout.setText(getTempString());
        tempLayout.setLocation(_locX, _locY);
        tempLayout.setColor(getTempColor());
    }
}
