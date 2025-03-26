import Toybox.Lang;
import Toybox.System;
import Toybox.Test;

function formatAs12Hour(hour as Lang.Number) as Lang.Number {
    if (hour == 0) {
        return 12;
    }

    return hour < 13
        ? hour
        : hour % 12;
}

(:test)
function testFormatAs12Hour(logger as Test.Logger) {
    var result = formatAs12Hour(0);
    Test.assert(result == 12);

    for (var i = 1; i < 13; i++) {
        result = formatAs12Hour(i);
        Test.assert(result == i);
    }

    for (var i = 13; i < 23; i++) {
        result = formatAs12Hour(i);
        Test.assert(result == i % 12);
    }

    return true;
 }

function formatAsZeroPaddedNumber(num as Lang.Number) as Lang.String {
    return num.format("%02d");
}

function formatHour(hour as Lang.Number) as Lang.String {
    var hourSetting = System.getDeviceSettings().is24Hour ? hour : formatAs12Hour(hour);
    return hourSetting.format("%d");
}

function formatMin(min as Lang.Number) as Lang.String {
    return formatAsZeroPaddedNumber(min);
}

function formatHoursAndMinutes(hour as Lang.Number, min as Lang.Number) as Lang.String {
    return Lang.format(
        "$1$:$2$",
        [
            System.getDeviceSettings().is24Hour ? hour : formatAs12Hour(hour),
            formatAsZeroPaddedNumber(min)
        ]
    );
}
