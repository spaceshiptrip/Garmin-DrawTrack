//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Application;

class MyApp extends Application.AppBase {

    var positionView;


    function initialize() {
        AppBase.initialize();
        
        System.println("FirstProperty=" + getProperty("FirstProperty"));
        
    }

    // onStart() is called on application start up
    function onStart(state) {
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }
    
    function onPosition(info) {
    	System.println(info.toString());
        positionView.onPosition(info);
    }

    // Return the initial view of your application here
    function getInitialView() {
//        return [new MyWatchView()];
        positionView = new MyWatchView();
        return [ positionView ];
    }

}
