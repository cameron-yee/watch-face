import Toybox.Activity;
import Toybox.Application;
import Toybox.Lang;
import Toybox.Position;

class ActivityInfoData {
    private var _activityInfo;

    function initialize() {
        _activityInfo = Activity.getActivityInfo();
    }

    function getCurrentLocation() as Position.Location or Null {
        if (_activityInfo != null && _activityInfo.currentLocation != null) {
            return _activityInfo.currentLocation;
        }

        var coordinates = Application.Storage.getValue("coordinates") as Lang.Array<Lang.Number>;
        if (coordinates == null) {
            return null;
        }
        var latitude = coordinates[0] as Lang.Number;
        var longitude = coordinates[1] as Lang.Number;
        return new Position.Location(
            {
                :latitude => latitude,
                :longitude => longitude,
                :format => :degrees
            }
        );
    }

    function getHR() as Lang.Number or Null {
        if (_activityInfo != null && _activityInfo.currentHeartRate != null) {
            return _activityInfo.currentHeartRate;
        }

        return null;
    }
}
