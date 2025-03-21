import Toybox.Lang;
import Toybox.System;

function formatAs12Hour(hour as Lang.Number) as Lang.Number {
    return hour < 13
      ? hour
      : hour % 12;
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
