//Sara
//***** DEPENDENCIES *****//
/*
* common_record.js - CommonRec
* Leaflet 0.7.3
* Esri-Leaflet v1.0.0
* jQuery 2.1.4
*/

//var hostname = document.location.host;
var xyzMap = {};

/****************** Namespace Variables ******************/
xyzMap.searchVars = {};

xyzMap.imgPath = "images/";

xyzMap.streetArray = [];

//**// Map Service Urls   
xyzMap.baseMapUrl = "https://hostname/arcgis/rest/services/Basemaps/map/MapServer";
xyzMap.imageryUrl = "https://hostname/arcgis/rest/services/img/MapServer";

/****************** END Namespace Variables ******************/









/****************** Create Map and Layers ******************/
xyzMap.map = L.map('map', 
    {
        center : [34.01,  - 118.32], zoom : 9
    });

xyzMap.baseMapLayer = L.esri.tiledMapLayer( {
    url : xyzMap.baseMapUrl
})
    .addTo(xyzMap.map);

/****************** END Create Map and Layers ******************/











/****************** Event Handlers ******************/
//** trigger an event on records page on map movement - prevents system from timing out when user on map page
xyzMap.map.on('move', function (evt) { 
    console.log('map move');
    window.opener.$('body').mousemove();
});

xyzMap.map.on('click', function (evt) { 
    console.log('map click');
    window.opener.$('body').mousemove();
    xyzMap.identifySelectClk(evt);
    window.opener.parent.CommonRec.clearOtherHighlight("map");
});

$("#importBlockIdBtn").click(function() { xyzMap.importBlockID(); });

xyzMap.createStreetClickHandler = function (searchFlag) {
    $('div#ADDRESS_TABLE').on('click', 'tr.streetRes', function () {
        var index = '';
        $('.highlighted').removeClass('highlighted');
        $(this).addClass('highlighted');
        index = $(this).children(":nth-child(2)").html();
        window.opener.parent.CommonRec.clearOtherHighlight("map"); //Clear the other highlights
        if (searchFlag == 'S') {
//            console.log(xyzMap.streetArray[index]);
            xyzMap.zoomToStreet(xyzMap.streetArray[index][1]);
            
        }
        else if (searchFlag == 'I') {
            var coords = xyzMap.intersectionArray[index][1]
            var x = coords[0];
            var y = coords[1];
            xyzMap.zoomToArea(x, y, 16);
            xyzMap.displayPin(y, x);
            
        };
    });
};

//**//********** import block on clicking 'Enter'
$(document).keypress(function(event){
    var keycode = (event.keyCode ? event.keyCode : event.which);
    if(keycode == '13'){
        xyzMap.enterClkImport();
    }
});
xyzMap.enterClkImport = function (){
        var blockID = xyzMap.returnBlock;
        var blockSt = blockID.substring(0, 2);
        var blockCou = blockID.substring(2, 5);
        var blockTract = blockID.substring(5, 11);
        var blockBlock = blockID.substring(11);
            
        window.opener.document.getElementById('selBlockState').value=blockSt;  
        window.opener.document.getElementById('selBlockCounty').value=blockCou;  
        window.opener.document.getElementById('selBlockId').value=blockBlock;  
        window.opener.document.getElementById('selTractId').value=blockTract; 
        
        window.opener.parent.CommonRec.AddressSearch();
        window.opener.parent.focus();
};
/****************** END Event Handlers ******************/









/****************** Map Styles ******************/
//marker icon style
xyzMap.markerIcon = L.icon( {
    iconUrl : xyzMap.imgPath + 'PinMarker_Red.png', iconSize : [27, 41], iconAnchor : [13.5, 41]
});

//block styling
xyzMap.blockFillStyle = {
    "color" : "#000000", "weight" : 5, "opacity" : 1, "fillColor" : "#0FF", "fillOpacity" : 0.25
};
xyzMap.blockOutlineStyle = {
    "color" : "#0FF", "weight" : 7, "opacity" : 1, "dashArray" : "1, 15"
};
/****************** END Map Styles ******************/










/****************** Find block on map click ******************/
xyzMap.identifySelectClk = function (evt) {
    xyzMap.mappnt = evt.latlng.lng + "," + evt.latlng.lat;
    xyzMap.evt = evt;
    var lng = xyzMap.evt.latlng.lng;
    var lat = xyzMap.evt.latlng.lat;
    
    $(".findBlockXYResult").remove();
    xyzMap.findBlockXY(lng, lat)
    .then(
        xyzMap.addBlockToMap
    );

};

xyzMap.findBlockXY = function (xcoord, ycoord) {
    var urlstring = xyzMap.baseMapUrl + "/1/query";
    var poststring = "geometry=" + xcoord + "%2C" + ycoord + "&geometryType=esriGeometryPoint&inSR=4326&spatialRel=esriSpatialRelIntersects"//&maxAllowableOffset=5000" //esriSpatialRelEnvelopeIntersects
    + "&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&outSR=4326&outFields=*&f=json";

    return $.ajax( {
        type : "GET", dataType : "json", url : urlstring + "?" + poststring
    });
};

xyzMap.addBlockToMap = function (jsonres) {
    console.log("ADD BLOCK TO MAP");
    console.log(jsonres);
    //check that an area with geometry was clicked on
    if (jsonres.features.length > 0) {
        xyzMap.returnBlock = jsonres.features[0].attributes.GEOID;
        //if there was a click on the map:
        //  1. add red pointer icon to map
        //  2. alert to user to confirm their selection
        if (xyzMap.evt) {
            //xyzMap.blockMarker ? xyzMap.map.removeLayer(xyzMap.blockMarker) : null;
            //xyzMap.mapMarker ? xyzMap.map.removeLayer(xyzMap.mapMarker) : null;
            xyzMap.clearHighlight();
            xyzMap.blockMarker = L.marker(xyzMap.evt.latlng, 
            {
                icon : xyzMap.markerIcon, alt : 'red pin'
            });
            xyzMap.blockMarker.addTo(xyzMap.map);

            //reset evt
            xyzMap.evt = null;
        };

        //outline the block and add it to the map
        	    xyzMap.makeBlock(jsonres.features[0].geometry.rings, xyzMap.blockFillStyle, xyzMap.blockOutlineStyle);
 	
        	    xyzMap.blockGeom.addTo(xyzMap.map);
        	    xyzMap.blockOutline.addTo(xyzMap.map);
                    //Store after obtain the block info for later use of [accept]
                xyzMap.storeBlockData();
    };
};

xyzMap.makeBlock = function (rings, blockFillStyle, blockOutlineStyle) {
    if (xyzMap.blockGeom) {
        xyzMap.map.removeLayer(xyzMap.blockGeom);
    };
    if (xyzMap.blockOutline) {
        xyzMap.map.removeLayer(xyzMap.blockOutline);
    };

    blockFillStyle = blockFillStyle || {};
    blockOutlineStyle = blockOutlineStyle || {};

    var geojsonFeature = {
        "type" : "Feature",
        "properties" :  {},
        "geometry" :  {
            "type" : "Polygon", "coordinates" : rings
        }
    };

    var geojsonFeatureOutline = {
        "type" : "Feature", "properties" :  {},
        "geometry" :  {
            "type" : "LineString", "coordinates" : rings[0]
        }
    };

    xyzMap.blockGeom = L.geoJson(geojsonFeature, 
    {
        style : blockFillStyle
    });
    xyzMap.blockOutline = L.geoJson(geojsonFeatureOutline, 
    {
        style : blockOutlineStyle
    });

    xyzMap.blockGeom.on('click', function (evt) {
        xyzMap.identifySelectClk(evt);
    });
    xyzMap.blockOutline.on('click', function (evt) {
        xyzMap.identifySelectClk(evt);
    });

};

xyzMap.storeBlockData = function (){ // function used to store the blockID when selected in navResults.jsp hidden input fields
                                        // function was inserted in cbFuncBlock() after data is retrieved
    var blockID = xyzMap.returnBlock;
    var blockSt = blockID.substring(0, 2);
    var blockCou = blockID.substring(2, 5);
    var blockTract = blockID.substring(5, 11);
    var blockBlock = blockID.substring(11);
    //Storing the data to a input field for 'Accept' record later
    window.opener.document.getElementById('selCodedTypeAndData').value="Map:"+blockSt+":"+blockCou+":"+blockTract+":"+blockBlock;
    window.opener.document.getElementById('selResults').value="Map Selected: "+blockSt+"-"+blockCou+"-"+blockTract+"-"+blockBlock+" ";
};
/****************** END Find block on map click ******************/









/****************** Import block to search page ******************/
xyzMap.importBlockID = function() {
    $.when($.ajax( {
        type : "POST",
        url : "CS?action=importBlockID",
        data :  {
            blockID : xyzMap.returnBlock
        }
        })
    )
    .then(
        xyzMap.transferBlockID
    );

};

xyzMap.transferBlockID = function (status) {
    console.log(status);
    var isplit = status.split(':');
    retStatus = isplit[0];
    message = isplit[1];
    blockSt = isplit[2];
    blockCou = isplit[3];
    blockTract = isplit[4];
    blockBlock = isplit[5];

    if (retStatus == "0") {
      //window.opener.location.reload(); //removed window reload
      //value set to the search window from import without reloading the main page
      window.opener.document.getElementById('selBlockState').value=blockSt;
      window.opener.document.getElementById('selBlockCounty').value=blockCou;
      window.opener.document.getElementById('selTractId').value=blockTract;
      window.opener.document.getElementById('selBlockId').value=blockBlock;
      
      alert(message);              
    }
    else {
        alert(message);
        //see what return false is for
        return false;
    } 
};
/****************** END Import block to search page ******************/









/****************** Clear Highlight on Main Page / Block Selection ******************/
xyzMap.clearHighlight = function (){ //Function used to clear the block map highlights
    if (xyzMap.blockGeom) {
        xyzMap.map.removeLayer(xyzMap.blockGeom);
    };
    if (xyzMap.blockOutline) {
        xyzMap.map.removeLayer(xyzMap.blockOutline);
    };
    if (xyzMap.blockMarker){
        xyzMap.map.removeLayer(xyzMap.blockMarker);
    };
    if (xyzMap.mapMarker){
        xyzMap.map.removeLayer(xyzMap.mapMarker);
    };
};

//function to remove the highlights of the MapList
xyzMap.clearHighlightMapList = function (){ 
    $('table tr').removeClass('highlighted');
};
/****************** END Clear Highlight on Main Page / Block Selection ******************/









/****************** Area Search ******************/
xyzMap.getZip = function() {
    var queryLayer = "/2";
    var whereClause = "zcta5='" + xyzMap.searchVars.zip + "'";
    var urlstring = xyzMap.baseMapUrl + queryLayer + "/query";
    var poststring = "geometryType=esriGeometryPoint&inSR=4326&spatialRel=esriSpatialRelIntersects" + "&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&outSR=4326&outFields=*&f=json" + "&where=" + encodeURIComponent(whereClause);
    
    return $.ajax({
        type : "GET", dataType : "json", url : urlstring + "?" + poststring
    });
};

xyzMap.processZipResults = function (jsonZipRes) {
    console.log('ajax result');
    console.log(jsonZipRes);
    
    //check if a zip was returned
    if ((jsonZipRes.features.length == 0)) {
        xyzMap.displaySearchError('No matches for zip ' + xyzMap.searchVars.zip + '.');
        return;
    }

    xyzMap.initZoomGeoJson = jsonZipRes;

    var geojsonZoomArea = {
        "type" : "Feature", "properties" :  {
            "name" : "Initial Zoom Area"
        },
        "geometry" :  {
            "type" : "MultiPolygon", "coordinates" : [jsonZipRes.features[0].geometry.rings]
        }
    };

    var zoomAreaGeom = L.geoJson(geojsonZoomArea);
    var zoomAreaExtent = zoomAreaGeom.getBounds();
          
    if ((xyzMap.userStreetSearch != null) && (xyzMap.userStreetSearch != '')) {

        xyzMap.findStreet(xyzMap.userStreetSearch,zoomAreaExtent)
        .then(
            xyzMap.processStreetResults
        );
    }
    //street not entered, zoom to zip
    else {
        var x = zoomAreaExtent.getCenter().lng;
        var y = zoomAreaExtent.getCenter().lat;
        xyzMap.zoomToArea(x, y, 14);
        xyzMap.displayPin(y, x);
    }
};

xyzMap.processStreetResults = function (jsonStreetRes) {     
    //if street found
    if (jsonStreetRes.results.length  > 0){
        //reset the array
        xyzMap.streetArray = xyzMap.createStreetArray(jsonStreetRes.results);
        console.log(xyzMap.streetArray);
        
        //display the first street result
        xyzMap.zoomToStreet(xyzMap.streetArray[0][1]);
        
        //create a table with all results
        xyzMap.displayTable(xyzMap.streetArray, 'S');
    }
    //street not found, zoom to zip
    else{
        var x = zoomAreaExtent.getCenter().lng;
        var y = zoomAreaExtent.getCenter().lat;
        xyzMap.zoomToArea(x, y, 14);
        xyzMap.displayPin(y, x);

        //display message that street not found and zip was used
        xyzMap.displaySearchError('No matches for street ' + xyzMap.userStreetSearch + '.<br> Zoomed to ZIP ' + xyzMap.searchVars.zip + '.')
    }
};
/****************** END Area Search ******************/









/****************** Street Intersection Search ******************/
xyzMap.streetIntSearch = function (searchSt1, searchSt2, searchZip) {
    if (!(searchSt1 && searchSt2)) {
        alert("Please enter two street names");
    }
    else {

        xyzMap.searchVars.zip = searchZip;

        var deferredSearchSt1 = $.Deferred();
        var deferredSearchSt2 = $.Deferred();
        
        searchSt1 = searchSt1.toUpperCase();
        searchSt2 = searchSt2.toUpperCase();

        xyzMap.getZip()
        .then(
            function(resp) {
                xyzMap.searchForStreetsInZip(resp, deferredSearchSt1, deferredSearchSt2);
            },
            function(failRes) {
                console.log("getZip request failed");
                console.log(failRes);
        });
        
        $.when(deferredSearchSt1, deferredSearchSt2)
        .then(
            function(r1, r2) {
                xyzMap.evaluateStreets(r1,r2);
                },
            function () {
                console.log("One of the deffered requests failed");
            }
        );
    };
};


xyzMap.searchForStreetsInZip = function (resp, deferredSearchSt1, deferredSearchSt2) {
    var geojsonSearchArea = {
        "type" : "Feature",
        "properties" :  {
            "name" : "Street Match Area"
        },
        "geometry" :  {
            "type" : "MultiPolygon", "coordinates" : [resp.features[0].geometry.rings]
        }
    };
    
    var searchAreaBounds = L.geoJson(geojsonSearchArea).getBounds();    
    
    //find each of the streets for the search
    xyzMap.findStreet(searchSt1, searchAreaBounds)
    .then(
        function(findAllStreetsRes) {
            console.log("DONE findAllStreets 1");
            console.log(findAllStreetsRes);
            deferredSearchSt1.resolve(findAllStreetsRes);
        },
        function() {
            deferredSearchSt1.reject("xyzMap.findAllStreets request 1 failed");
        }
    );
        
    //add function to not perform this search if it's the same street, resolve with empty object
    xyzMap.findStreet(searchSt2, searchAreaBounds)
    .then(
        function(findAllStreetsRes) {
            console.log("DONE findAllStreets 2");
            console.log(findAllStreetsRes);
            deferredSearchSt2.resolve(findAllStreetsRes);
        },
        function() {
            deferredSearchSt2.reject("xyzMap.findAllStreets request 2 failed");
        }
    );
};

xyzMap.evaluateStreets = function (r1, r2) {
    console.log("BOTH STREET SEARCHES DONE");
    console.log(searchSt1 === searchSt2);
    console.log(r1);
    console.log(r2);
    xyzMap.displaySearchCriteria(searchSt1, searchSt2, xyzMap.searchVars.zip);
    //If streets have the same name, and we were able to locate that street
    if (searchSt1 === searchSt2 && r1.results.length !== 0) {
        xyzMap.findIntersectionsOneStreet(r1.results);
        console.log(xyzMap.intersectionArray);
        if (xyzMap.intersectionArray.length > 0) {
            xyzMap.displayTable(xyzMap.intersectionArray, 'I');
        }
        else {
            //zoom to street in Street field
            xyzMap.zoomToStreet(r1.results[0].geometry.paths);
            xyzMap.displaySearchError("Those streets do not intersect. Zoomed to first result for " + searchSt1 + ".");
        };
    //else if streets don't have the same name
    } else if (searchSt1 !== searchSt2) {
        if (r1.results.length === 0 && r2.results.length === 0) {
            xyzMap.displaySearchError("Neither street could be found.");
        }
        else if (r1.results.length !== 0 && r2.results.length === 0) {
            xyzMap.streetArray = xyzMap.createStreetArray(r1.results);
            xyzMap.displaySearchError("Only " + searchSt1 + " found.");
            xyzMap.displayTable(xyzMap.streetArray, 'S');
        }
        else if (r1.results.length === 0 && r2.results.length !== 0) {
            xyzMap.streetArray = xyzMap.createStreetArray(r2.results);
            xyzMap.displaySearchError("Only " + searchSt2 + " found.");
            xyzMap.displayTable(xyzMap.streetArray, 'S');
        }
        else {
            xyzMap.findIntersections(r1.results, r2.results);
            console.log(xyzMap.intersectionArray);
            if (xyzMap.intersectionArray.length > 0) {
                xyzMap.displayTable(xyzMap.intersectionArray, 'I');
            }
            else {
                //zoom to street in Street field
                xyzMap.zoomToStreet(r1.results[0].geometry.paths);
                xyzMap.displaySearchError("Those streets do not intersect. Zoomed to first result for " + searchSt1 + ".");
            };
        }
    };
};

xyzMap.findStreet = function (searchSt, searchAreaBounds) {
    var geoCoords = searchAreaBounds.getWest() + "," + searchAreaBounds.getSouth() + "," + searchAreaBounds.getEast() + "," + searchAreaBounds.getNorth();
    var geoType = "esriGeometryEnvelope";

    //search for street names
    var whereClause = "upper(basename) = '" + searchSt + "'";
    
    var urlstring = xyzMap.baseMapUrl + "/identify";
    var poststring = "geometry=" + encodeURIComponent(geoCoords) + "&geometryType=" + geoType + "&mapExtent=" + encodeURIComponent(geoCoords) + "&layers=all%3A" + encodeURIComponent("3,4,5") + "&layerDefs=" + encodeURIComponent("3:" + whereClause + ";4:" + whereClause + ";5:" + whereClause) + "&tolerance=1&sr=4326&time=&layerTimeOptions=&imageDisplay=100%2C100%2C96&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&dynamicLayers=&returnZ=false&returnM=false&gdbVersion=&f=json";
    
    return $.ajax({
        type : "GET", dataType : "json", url : urlstring + "?" + poststring
    });

};

xyzMap.findIntersectionsOneStreet = function (searchSt1, searchSt2) {
    console.log("findIntersectionsOneStreet");
    xyzMap.intersectionArray = [];
    var street1Array = searchSt1.map(xyzMap.streetIntersectionDisplayArray);
    console.log("street1Array", street1Array);    
    
    for (var i=0, len=street1Array.length; i < len-2; i++) {
        for (var j=i+1; j < len; j++) {
            if (street1Array[i]['name'] === street1Array[j]['name']
            || street1Array[i]['streetLen'] === street1Array[j]['streetLen']) {
                continue;
            } else {
                street1Array[i].coords.forEach(function (st1Coord) {
                    street1Array[j].coords.forEach(function (st2Coord) {
            
                        if (st1Coord[0] == st2Coord[0] && st1Coord[0] == st2Coord[0]) {
                            xyzMap.intersectionArray.push([street1Array[i]['name'] + " & " + street1Array[j]['name'], st1Coord]);
                            return;
                        };
                        
                    });
                });
            };
        };
    };
};

xyzMap.findIntersections = function (searchSt1, searchSt2) {
    console.log("findIntersections");
    xyzMap.intersectionArray = [];
    var street1Array = searchSt1.map(xyzMap.streetIntersectionDisplayArray);
    var street2Array = searchSt2.map(xyzMap.streetIntersectionDisplayArray);
    console.log("street1Array", street1Array);    
    console.log("street2Array", street2Array);    
    street1Array.forEach(function (st1Obj) {
        street2Array.forEach(function (st2Obj) {
            
                st1Obj.coords.forEach(function (st1Coord) {
                    st2Obj.coords.forEach(function (st2Coord) {
            
                        if (st1Coord[0] == st2Coord[0] && st1Coord[0] == st2Coord[0]) {
                            xyzMap.intersectionArray.push([st1Obj.name + " & " + st2Obj.name, st1Coord]);
                            return;
                        };
                        
                    });
                });
                
        });
    });
};

xyzMap.streetIntersectionDisplayArray = function (obj) {
    retObj = {};
    retObj['name'] = obj.attributes['NAME'];
    retObj['coords'] = obj.geometry.paths[0];
    retObj['objectid'] = obj.attributes['OBJECTID'];
    retObj['streetLen'] = obj.attributes['STGEOMETRY.LEN'];
    return retObj;  
};
    
xyzMap.createStreetArray = function (jsonResults) {
    var retArray = [];
    var streetNameConcat = ""

    for (var i = 0;i < jsonResults.length;i++) {

        //build the street name
        streetNameConcat = '';
        streetNameConcat = [jsonResults[i].attributes['NAME']];
//        streetNameConcat = [jsonResults[i].attributes['PREQUAL'], jsonResults[i].attributes['PREDIR'], jsonResults[i].attributes['PRETYP'], jsonResults[i].attributes['NAME'], jsonResults[i].attributes['SUFDIR'], jsonResults[i].attributes['SUFQUAL'], jsonResults[i].attributes['SUFTYP'], ].filter(function (str) {
//            if (str != 'Null') {
//                return str;
//            }
//            return '';
//        }).join(' ');

        //add the street/geometry combo to the area for later use
        retArray.push([streetNameConcat, jsonResults[i].geometry.paths]);
};

    return retArray;
};

/****************** END Street Intersection Search ******************/









/****************** Single Street Search ******************/
xyzMap.streetZipSearch = function(selStreet, selZip){
    
    //convert to uppercase
    xyzMap.userStreetSearch = selStreet.toUpperCase();
    xyzMap.searchVars.zip = selZip;
    
    var queryLayer = "";
    var whereClause = "";
    
    //setup a zip query
    if (selZip && selZip !== '00000' && selZip.trim().length === 5) {
        queryLayer = "/2";
        whereClause = "zcta5='" + xyzMap.searchVars.zip + "'";
    }
    else {
        alert('Please enter a proper ZIP code.');
        return;
    }
     
    xyzMap.displaySearchCriteria(xyzMap.userStreetSearch, null, xyzMap.searchVars.zip);

	xyzMap.getZip()
    .then(xyzMap.processZipResults);
};
/****************** END Single Street Search ******************/









/****************** Map zoom events ******************/
xyzMap.zoomToArea = function zoomToArea(xcoord, ycoord, zoomNum) {
    console.log("ZOOM TO AREA");
    console.log([xcoord, ycoord]);
    xyzMap.map.setView([ycoord, xcoord], zoomNum);
};

xyzMap.zoomToStreet = function(geometryPaths){
    
    //console.log("zoomToStreet called");

    var middle = geometryPaths[0][Math.floor(geometryPaths[0].length/2)];
    console.log(middle);
    var geojsonZoomStreet = {
        "type" : "Feature", "properties" :  {
            "name" : "Zoom To Street", 
        },
        "geometry" :  {
            "type" : "Point", "coordinates" : middle
        }
    };

    var zoomAreaStreet = L.geoJson(geojsonZoomStreet);
    var x = zoomAreaStreet.getBounds().getCenter().lng;
    var y = zoomAreaStreet.getBounds().getCenter().lat;

    xyzMap.zoomToArea(x, y, 16);
    xyzMap.displayPin(y, x);

};
/****************** END Map zoom events ******************/









/****************** Map display elements ******************/
//takes the y,x in the same order as the L.marker function
xyzMap.displayPin = function(y,x){
    xyzMap.clearHighlight();      
    //display a pin in the center
    xyzMap.mapMarker = L.marker([y, x], 
        {
            icon : xyzMap.markerIcon, alt : 'red pin'
        });
    xyzMap.mapMarker.addTo(xyzMap.map);
};

xyzMap.displaySearchCriteria = function displaySearchCriteria(streetName, intStreetName, zip) {
    $('#SEARCH_DISPLAY').append('<b>Search Criteria</b><br>');
    if ((streetName !== null) && (intStreetName !== null) && (zip !== null)) {
        $('#SEARCH_DISPLAY').append('Street: ' + streetName + '<br>');
        $('#SEARCH_DISPLAY').append('Int Street: ' + intStreetName + '<br>');
        $('#SEARCH_DISPLAY').append('ZIP Code: ' + zip + '<br>');
    }
    else if ((streetName !== null) && (zip !== null)) {
        $('#SEARCH_DISPLAY').append('Street: ' + streetName + '<br>');
        $('#SEARCH_DISPLAY').append('ZIP Code: ' + zip + '<br>');
    }
};

xyzMap.displaySearchError = function (errorMessage) {
    $('#SEARCH_DISPLAY').append('<span style="color: red; font-size: small;"><b><i>' + errorMessage + '</i></b></span><br>');
};

xyzMap.displayTable = function displayTable (streetArray, searchFlag){
    var tableBodyID = '';
    
    //create the tables based on searchFlag
    if (searchFlag == 'S'){
        var newTableHeader = $('<table id="DISP_MAP_TAB"><thead><tr><th>Street</th></tr></thead></table>').addClass('DISP_MAP_TAB');
        var newTableBody = $('<table id="tblStreetRes"><tbody class="scrollContent2"></tbody></table>').addClass('DISP_MAP_TAB'); 
        tableBodyID = '#tblStreetRes';
    }
    else if (searchFlag == 'I'){
        var coords = xyzMap.intersectionArray[0][1]
        var x = coords[0];
        var y = coords[1];
        xyzMap.zoomToArea(x, y, 16);
        xyzMap.displayPin(y, x);

        var newTableHeader = $('<table id="DISP_MAP_TAB"><thead><tr><th>Intersecting Streets</th></tr></thead></table>').addClass('DISP_MAP_TAB');
        var newTableBody = $('<table id="tblIntStreetRes"><tbody class="scrollContent2"></tbody></table>').addClass('DISP_MAP_TAB'); 
        tableBodyID = '#tblIntStreetRes';
    };

    xyzMap.createStreetClickHandler(searchFlag);

    $('#ADDRESS_TABLE').append(newTableHeader);
    $('#ADDRESS_TABLE').append(newTableBody);
    
    //add the table rows
    var newRow = '';
    for(var i=0; i < streetArray.length; i++){
        newRow = '';
        if (i == 0) {
            newRow = newRow + '<tr class="streetRes highlighted"><td>' + streetArray[i][0] + '</td>';
        }
        else {
            newRow = newRow + '<tr class="streetRes"><td>' + streetArray[i][0] + '</td>';
        }
        newRow = newRow + '<td style="width:0%;display:none;">' + i + '</td></tr>';
        $(tableBodyID).append(newRow);
     }
};
/****************** END Map display elements ******************/