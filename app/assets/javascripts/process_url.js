function processUrl() {
  var urlAddress = getUrlVar("address");
  var urlLat = getUrlVar("lat");
  var urlLong = getUrlVar("long");
  var urlDistrict = getUrlVar("district");
  console.log("address: " + urlAddress);
  console.log("lat: " + urlLat);
  console.log("lon: " + urlLong);
  console.log("district: " + urlDistrict);
  if(urlAddress && urlAddress != '') {
    updatePage({'address': urlAddress});
    console.log("address is not empty");
  } else if (urlLat && urlLat != '' && urlLong && urlLong != '') {
    updatePage({'lat': urlLat, 'long': urlLong});
    console.log("lat and long are not empty");
  } else if (urlDistrict && urlDistrict != '') {
    updatePage({'district': urlDistrict});
  }
}