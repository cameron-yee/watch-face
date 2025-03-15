import Toybox.Lang;

function formatAs12Hour(hour as Lang.Number) as Lang.Number {
    return hour < 13
      ? hour
      : hour % 12;
}

function formatAsZeroPaddedNumber(num as Lang.Number) as Lang.String {
    return num.format("%02d");
}

function formatHoursAndMinutes(hour as Lang.Number, min as Lang.Number) as Lang.String {
    return Lang.format(
        "$1$:$2$",
        [
            formatAs12Hour(hour),
            formatAsZeroPaddedNumber(min)
        ]
    );
}
