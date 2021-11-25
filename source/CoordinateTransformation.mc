// This class does the coordinate transforms from real-world to screen-world coordinates
// There is some fudge factor in order to draw it the right size for the screen
class CoordinateTransformation {

	var currLocDeg; // current location in degrees
	var currLocRad; // current location in radians
	
	//actual point on map
	var currLocLatDeg = 34.19536;
	var currLocLonDeg = -118.21215;
	
	var currLocLatRad;
	var currLocLonRad;
	
	var currLocScreenX;
	var currLocScreenY;
	
	var QUARTER_PI = Math.PI / 4;
	
	var DISPLAY_PADDING = 2;
	var DISPLAY_HEIGHT  = 180;
	var DISPLAY_WIDTH   = 215;

    // Fudge factors depending on the screen resolution
    // TODO compute this programmatically to eliminate the FUDGE
	var minX = -2.062456158852299;
    var minY = 0.6357554191207595;
    var maxX = 0.00935990988441926;
    var maxY = 0.004003124971883487;

//	var minX = -2.0639926885539306;
//    var minY = 0.6353264897906945;
//    var maxX = 0.0008824384698082;
//    var maxY = 0.0006327755713624;
    
    var currLocFromGPS;


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

		// The reason we need to determine the min X and Y values is
		// because in order to draw the map,
		// we need to offset the position so that there will be no
		// negative X and Y values
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

		// need to invert the Y since 0,0 starts at top left
		currLocScreenY = ((DISPLAY_HEIGHT - heightPadding - (positiveY * globalRatio))).toNumber();
    }
    
    
    // Next funtion allows an arrowhead to be used as the asset marker
    // allowing for direction to be displayed
    // Still work in progress
    // Simple rotation function: https://en.wikipedia.org/wiki/Rotation_(mathematics)
    // Given a point (x, y) and angle theta, rotate that point around angle
    // x' = x * cos (theta) - y * sin (theta)
    // y' = x * sin (theta) - y * cos (theta)
    //
    // return point
    function rotatePointToHeading() {
        
    }
 }