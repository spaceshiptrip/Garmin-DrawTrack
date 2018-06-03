//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Position;
using Toybox.System;
using Toybox.Math;


class MyWatchView extends WatchUi.View {

    var train;
    var backdrop;
    var gpxTrack;
    var blueArrow;
    var blueCircle;
    var MAP_WIDTH;
    var MAP_HEIGHT;
    var latLon = new[5];
    var points = new[5];
    
    var locCtrX = 52;
	var locCtrY = 112;
	var markerImgHeight = 14;
	var markerImgWidth  = 14;
	
	var currLocDeg; // current location in degrees
	var currLocRad; // current location in radians
	
	//actual point on AC map
	var currLocLatDeg = 34.203490;
	var currLocLonDeg = -118.210360;
	
	var currLocLatRad;
	var currLocLonRad;
	
	var currLocScreenX;
	var currLocScreenY;
	
	var QUARTER_PI = Math.PI / 4;
	
	var DISPLAY_PADDING = 2;
	var DISPLAY_HEIGHT  = 180;
	var DISPLAY_WIDTH   = 215;
	
//	var minX = -2.062456158852299;
//    var minY = 0.6357554191207595;
//    var maxX = 0.00935990988441926;
//    var maxY = 0.004003124971883487;

	var minX = -2.06245615885229;
    var minY = 0.6353264897906945;
    var maxX = 0.0008824384698082;
    var maxY = 0.0006327755713624;

    
    var currLocFromGPS;
	
	
    // Constructor
    function initialize() {
        View.initialize();
        train    = new Rez.Drawables.train();
        backdrop = new Rez.Drawables.backdrop();
        gpxTrack = new WatchUi.Bitmap({:rezId=>Rez.Drawables.gpxTrack,:locX=>0,:locY=>0});
        blueCircle = new WatchUi.Bitmap({:rezId=>Rez.Drawables.circle,:locX=>174,:locY=>33});
        
        
//      LOCATION_ONE_SHOT for a single location request
//		LOCATION_CONTINUOUS to enable location tracking
//		LOCATION_DISABLE to turn off location tracking
//        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));

		currLocFromGPS = Activity.getActivityInfo().currentLocation;
		if (currLocFromGPS != null) {
			currLocLatDeg = currLocFromGPS.toDegrees()[1].toFloat();
			currLocLatDeg = currLocFromGPS.toDegrees()[0].toFloat();
		}
        
        // TODO FAKE THE LOCATION
		currLocLatRad = currLocLatDeg * Math.PI / 180;
		currLocLonRad = currLocLonDeg * Math.PI / 180;
    }

    // Load your resources here
    function onLayout(dc) {
        //WatchUi.animate( cloud, :locX, WatchUi.ANIM_TYPE_LINEAR, 10, dc.getWidth() + 50, 10, null );
//        DISPLAY_HEIGHT = dc.getHeight();
//        DISPLAY_WIDTH = dc.getWidth();
    }

    function onShow() {
    }
    
    
    // call onPosition() each time the position is updated
    // don't have to specifically call onPosition from onDisplay()
    function onPosition(info) {
    	currLocDeg = info.position.toDegrees();
    	currLocRad = info.position.toRadians();
    	
    	currLocLatRad = currLocRad[0];
    	currLocLonRad = currLocRad[1];
    	
    	System.println(currLocDeg[0]); // latitude (e.g. 38.856147)
    	System.println(currLocDeg[1]); // longitude (e.g -94.800953)
    	
    	WatchUi.requestUpdate();
    	
    	// TODO FAKE THE LOCATION
//		currLocLatRad = currLocLatDeg * Math.PI / 180;
//		currLocLonRad = currLocLonDeg * Math.PI / 180;
	}

    // Update the view
    function onUpdate(dc) {

		gpxTrack.draw(dc);
		
		currLocFromGPS = Activity.getActivityInfo().currentLocation;
		if (currLocFromGPS != null) {
			currLocLatDeg = currLocFromGPS.toDegrees()[1].toFloat();
			currLocLatDeg = currLocFromGPS.toDegrees()[0].toFloat();
		}
        
        // TODO FAKE THE LOCATION
		currLocLatRad = currLocLatDeg * Math.PI / 180;
		currLocLonRad = currLocLonDeg * Math.PI / 180;
		
    	convertToScreenCoordinates();
    	System.println("computed screen coords: " + currLocScreenX + ", " + currLocScreenY);
    	
        blueCircle.setLocation(currLocScreenX - markerImgWidth/2, currLocScreenY - markerImgHeight/2);
        blueCircle.draw(dc);
		
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLUE);
		
		locCtrX = currLocScreenX;
		locCtrY = currLocScreenY;
		
        dc.drawPoint(locCtrX, locCtrY);
        dc.drawPoint(locCtrX + 1, locCtrY + 1);
        dc.drawPoint(locCtrX - 1, locCtrY - 1);
        dc.drawPoint(locCtrX + 1, locCtrY - 1);
        dc.drawPoint(locCtrX - 1, locCtrY + 1);
        dc.drawPoint(locCtrX + 1, locCtrY);
        dc.drawPoint(locCtrX - 1, locCtrY);
        dc.drawPoint(locCtrX, locCtrY + 1);
        dc.drawPoint(locCtrX, locCtrY - 1);        
        
        //backdrop.draw(dc);
        //train.draw(dc);
    }
    
    //TODO The software has to know the min and the max
    //TODO there has to be a way to pass the information along to the software
    //TODO is there a way to read the data from a file?
    //TODO maybe that is why it has to connect to the server, it passes along information
    //TODO upon each map when they are loaded
    // Start porting the computation to convert GPS coordinates to screen coordinates
    function convertToScreenCoordinates() {

        //convert the longitude/latitude to X/Y using Mercator projection formula
        var mercatorX = currLocLonRad;
        var mercatorY = Math.log(Math.tan(QUARTER_PI + 0.5 * currLocLatRad), Math.E); // need LOG(TAN(PI/4 + 0.5 * currLocLatRad

		if ( (minX == -1) || (minX > mercatorX) ) {
		    minX = mercatorX;
		} 
		
		if ( (minY == -1) || (minY > mercatorY) ) {
		    minY = mercatorY;
		} 
		
		// process to eliminate negatives
		// readjust coordinate to ensure there are no negative values
        var positiveX = mercatorX - minX;
        var positiveY = mercatorY - minY;
        
        if ( (maxX == -1) || (maxX < positiveX) ) {
            maxX = positiveX;
        }
        
        if ( (maxY == -1) || (maxY < positiveY) ) {
            maxY = positiveY;
        }
        
        // Take into account the padding
        var paddingBothSides = DISPLAY_PADDING * 2;
         
        // the actual drawing space for the map on the image
		var mapWidth  = DISPLAY_WIDTH  - paddingBothSides;
        var mapHeight = DISPLAY_HEIGHT - paddingBothSides;
        
        // determine the width and height ratio because we need to magnify the map to fit into the given image dimension
        var mapWidthRatio  = mapWidth / maxX;
        var mapHeightRatio = mapHeight / maxY;        
         
		// using different ratios for width and height will cause the map to be stretched. So, we have to determine
        // the global ratio that will perfectly fit into the given image dimension
        var globalRatio;
        
        if (mapWidthRatio < mapHeightRatio) {
            globalRatio = mapWidthRatio;
        } else {
            globalRatio = mapHeightRatio;
        }

        // now we need to readjust the padding to ensure the map is always drawn on the center of the given image dimension
        var heightPadding = (DISPLAY_HEIGHT - (globalRatio * maxY)) / 2;
        var widthPadding  = (DISPLAY_WIDTH  - (globalRatio * maxX)) / 2;
        
        // compute the actual screen coordinates capable of being drawn onscreen
       	currLocScreenX = (widthPadding + (positiveX * globalRatio)).toNumber();
       	//currLocScreenX = currLocScreenXF.toNumber();

		// need to invert the Y since 0,0 starts at top left
		currLocScreenY = ((DISPLAY_HEIGHT - heightPadding - (positiveY * globalRatio))).toNumber();
		//currLocScreenY = currLocScreenYF.toNumber();
    }
    
    // This method is called when the device re-enters sleep mode.
    // Set the isAwake flag to let onUpdate know it should stop rendering the second hand.
    function onEnterSleep() {
        WatchUi.requestUpdate();
    }

}
