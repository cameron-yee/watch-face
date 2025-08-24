//
// Copyright 2016-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

//! Handles the behavior / input events
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
