import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class InputDelegate extends WatchUi.BehaviorDelegate {
    private var _parentView as $.View;

    public function initialize(view as $.View) {
        BehaviorDelegate.initialize();
        _parentView = view;
    }

    public function onTap(clickEvent) {
        _parentView.setAction("TAP");
        return true;
    }

    public function onSwipe(swipeEvent) {
        _parentView.setAction("SWIPE");
        return true;
    }
}
