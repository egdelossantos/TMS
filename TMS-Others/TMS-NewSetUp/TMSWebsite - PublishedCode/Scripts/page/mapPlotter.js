function plotAddressInMap(addresses, mapElement) {
    var addressCount = addresses.length;
    var middleIndex = 0;
    if (addressCount <= 0) {
        return;
    }
    else if (addressCount > 5) {
        middleIndex = Math.floor(addressCount / 2);
    }

    var middleAddress = addresses[middleIndex];
    var mapProp = {
        center: new google.maps.LatLng(middleAddress.Latitude, middleAddress.Longtitude),
        zoom: 10,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(mapElement, mapProp);
    var bounds = new google.maps.LatLngBounds();

    jQuery.each(addresses, function (i, address) {
        console.log(address);

        addMarker(address.Latitude, address.Longtitude, address.AddressDisplay, address.RouteOrder, address.MapMarkerColour);
    });

    map.fitBounds(bounds);

    function addMarker(x, y, title, routeOrder, mapMarkerColor) {
        if (mapMarkerColor == undefined || mapMarkerColor == null || mapMarkerColor == "") {
            mapMarkerColor = "red";
        }
        var _mapMarkerColor = "http://maps.google.com/intl/en_us/mapfiles/ms/micons/" + mapMarkerColor + ".png";
        var location = new google.maps.LatLng(x, y);
        var infoWindow = new google.maps.InfoWindow();
        var marker1 = new google.maps.Marker({
            position: location,
            map: map,
            title: title,
            icon: _mapMarkerColor
        });

        bounds.extend(marker1.position);
        
        var marker = new MarkerWithLabel({
            position: location,
            map: map,
            title: title,
            labelContent: routeOrder,
            labelAnchor: new google.maps.Point(7, 32),
            labelClass: "labels", // the CSS class for the label
            labelInBackground: false,
            icon: _mapMarkerColor
        });

        google.maps.event.addListener(marker, "click", function (e) {
            infoWindow.setContent(title);
            infoWindow.open(map, marker1);
        });

        google.maps.event.addListener(marker1, "mouseout", function (e) {
            infoWindow.close(map, marker1);
        });
    }
}