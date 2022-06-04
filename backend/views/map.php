<?php
$messages = Messages::getAllMessages();
?>
<!DOCTYPE html>
<html>

<head>
  <title>Vuvuzetla</title>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
  <link rel="stylesheet" href="assets/css/main.css" />
  <noscript>
    <link rel="stylesheet" href="assets/css/noscript.css" />
  </noscript>

  <link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
  <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png" />
  <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png" />
  <link rel="manifest" href="/site.webmanifest" />
  <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5" />
  <meta name="msapplication-TileColor" content="#da532c" />
  <meta name="theme-color" content="#ffffff" />

  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.8.0/dist/leaflet.css" integrity="sha512-hoalWLoI8r4UszCkZ5kL8vayOGVae1oxXe/2A4AO6J9+580uKHDO3JdHb7NzwwzK5xr/Fs0W40kiNHxM9vyTtQ==" crossorigin="" />

  <!-- Make sure you put this AFTER Leaflet's CSS -->
  <script src="https://unpkg.com/leaflet@1.8.0/dist/leaflet.js" integrity="sha512-BB3hKbKWOc9Ez/TAwyWxNXeoV9c1v6FIeYiBieIWkpLjauysF18NzgR1MBNBXf8/KABdlkX68nAhlwcDFLGPCQ==" crossorigin=""></script>
  <style>
    #map {
      height: 500px;
    }
  </style>


</head>

<body>
  <div id="map"></div>
  <div>
    <table>
      <tr>
        <th>id</th>
        <th>message</th>
        <th>category</th>
        <th>username</th>
        <th>uuid</th>
        <th>actions</th>
      </tr>
      <?php
      foreach ($messages as $m) {
        echo "<tr>" .
          "<td>" . $m->id . "</td>" .
          "<td>" . $m->message . "</td>" .
          "<td>" . $m->category . "</td>" .
          "<td>" . $m->username . "</td>" .
          "<td>" . $m->uuid . "</td>" .
          "<td>" .
          "<a href=\"/?a=vuvuzetla..ever!&d=c&id=" . $m->id . "\"><button>Censure</button></a>" .
          "<a href=\"/?a=vuvuzetla..ever!&d=d&id=" . $m->id . "\"><button>Supression</button></a>" .
          "<a href=\"/?a=vuvuzetla..ever!&d=du&id=" . $m->uuid . "\"><button>Supr. Utilisateur</button></a>" .
          "</td>" .
          "</tr>";
      }
      ?>
    </table>
  </div>
</body>
<script>
  var map = L.map('map').setView([51.505, -0.09], 5);
  L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox/streets-v11',
    tileSize: 512,
    zoomOffset: -1,
    accessToken: ''
  }).addTo(map);

  <?php
  $i = 0;
  foreach ($messages as $m) {
    echo 'var marker' . $i . ' = L.marker([' . $m->latitude . ', ' . $m->longitude . ']).addTo(map);';
    echo 'marker' . $i . '.bindPopup("<b>' . $m->id . '</b> - ' . $m->username . '<br>' . $m->message . '");';
    echo "var circle" . $i . " = L.circle([" . $m->latitude . ", " . $m->longitude . "], {color: 'red', fillColor: '#f03', fillOpacity: 0.01, radius: 2000 }).addTo(map);";
    $i++;
  }
  ?>
</script>

</html>
