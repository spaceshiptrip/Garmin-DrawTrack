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

class MyWatchView extends WatchUi.View {

    var train;
    var backdrop;
    var cloud;
    var MAP_WIDTH;
    var MAP_HEIGHT;
    var latLon = new[5];
    var points = new[5];

    // Constructor
    function initialize() {
        View.initialize();
        train = new Rez.Drawables.train();
        backdrop = new Rez.Drawables.backdrop();
        cloud = new WatchUi.Bitmap({:rezId=>Rez.Drawables.cloud,:locX=>10,:locY=>30});
        
//lat="37.778259000" lon="-122.391386000">
//lat="37.778194000" lon="-122.391226000">
//lat="37.778297000" lon="-122.391174000">
//lat="37.778378000" lon="-122.391117000">
//lat="37.778449000" lon="-122.391039000">
//lat="37.778525000" lon="-122.390942000">
// Initialize the sub-arrays
for( var i = 0; i < 5; i += 1 ) {
    latLon[i] = new [2];
}

        latLon[0][0] = 37.778194000;
        latLon[0][1] = -122.391226000;
        latLon[1][0] = 37.778297000;
        latLon[1][1] = -122.391174000;
        latLon[2][0] = 37.778378000;
        latLon[2][1] = -122.391117000;
        latLon[3][0] = 37.778449000;
        latLon[3][1] = -122.391039000;
        latLon[4][0] = 37.778525000;
        latLon[4][1] = -122.390942000;
        
        for( var i = 0; i < 5; i += 1 ) {
            points[i] = new [2];
        } 

    }

    // Load your resources here
    function onLayout(dc) {
        //WatchUi.animate( cloud, :locX, WatchUi.ANIM_TYPE_LINEAR, 10, dc.getWidth() + 50, 10, null );
        MAP_HEIGHT = dc.getHeight();
        MAP_WIDTH = dc.getWidth();
        
        for (var i=0; i<5; i++) {
            // it is minus because 
            points[i][0] = ((MAP_HEIGHT/180.0) * (90 - latLon[i][0]));
            points[i][1] = ((MAP_WIDTH/360.0) * (180 + latLon[i][1]));
        }
        

        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        
        for (var i=0; i<5; i++) {
          System.println(i + ": " + points[i][0] + ", " + points[i][1]);
          dc.drawPoint(points[i][0], points[i][1]);
        }
       // var x =  (int) ((MAP_WIDTH/360.0) * (180 + lon));
       // var y =  (int) ((MAP_HEIGHT/180.0) * (90 - lat));
        
        
    }

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
//        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
//        dc.fillRectangle(0, 0, dc.getWidth(), dc.getHeight());
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        
//        for (var i=0; i<5; i++) {
//          dc.drawPoint(points[i][0], points[i][1]);
//        }
        
        dc.drawPoint(MAP_HEIGHT/2, MAP_WIDTH/2);
        dc.drawPoint(MAP_HEIGHT/2 + 1, MAP_WIDTH/2 + 1);
        dc.drawPoint(MAP_HEIGHT/2 - 1, MAP_WIDTH/2 - 1);
        dc.drawPoint(MAP_HEIGHT/2 + 1, MAP_WIDTH/2 - 1);
        dc.drawPoint(MAP_HEIGHT/2 - 1, MAP_WIDTH/2 + 1);
        dc.drawPoint(MAP_HEIGHT/2 + 1, MAP_WIDTH/2);
        dc.drawPoint(MAP_HEIGHT/2 - 1, MAP_WIDTH/2);
        dc.drawPoint(MAP_HEIGHT/2, MAP_WIDTH/2 + 1);
        dc.drawPoint(MAP_HEIGHT/2, MAP_WIDTH/2 - 1);
        
        
        //backdrop.draw(dc);
        //train.draw(dc);
        //cloud.draw(dc);
    }

}
