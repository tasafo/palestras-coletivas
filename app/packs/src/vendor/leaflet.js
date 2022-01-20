import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

/* This code is needed to properly load the images in the Leaflet CSS */
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});

var event_coordinates_0 = document.getElementById("event_coordinates_0");
var event_coordinates_1 = document.getElementById("event_coordinates_1");

if (event_coordinates_0 != null) {
  event_coordinates_0 = event_coordinates_0.innerText;
  event_coordinates_1 = event_coordinates_1.innerText;

  var map = L.map('location-map').setView([event_coordinates_1, event_coordinates_0], 17);
  var mapLink = '<a href="https://openstreetmap.org">OpenStreetMap</a>';

  L.tileLayer(
    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; ' + mapLink,
    maxZoom: 20,
  }).addTo(map);

  var marker = L.marker([event_coordinates_1, event_coordinates_0]).addTo(map);
}
