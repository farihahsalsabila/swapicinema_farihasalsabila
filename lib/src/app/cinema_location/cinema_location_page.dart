import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class CinemaLocationPage extends StatefulWidget {
  const CinemaLocationPage({super.key});

  @override
  State<CinemaLocationPage> createState() => _CinemaLocationPageState();
}

class _CinemaLocationPageState extends State<CinemaLocationPage> {
  static const LatLng _currentPosition = LatLng(-6.2013304, 106.9563909);

  final MapController _mapController = MapController();
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.82);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _cinemas = [
    {
      'id': '1',
      'name': 'AEON Tanjung Barat XXI',
      'address': 'AEON Mall Tanjung Barat, RT.2/RW.1, Tj. Bar., Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12530',
      'latLng': const LatLng(-6.3070401, 106.8399462),
      'eta': '28 mins (24.9 km)',
    },
    {
      'id': '2',
      'name': 'Kelapa Gading XXI',
      'address': 'Jl. Boulevard Raya, RT.13/RW.18, Klp. Gading Tim., Kec. Klp. Gading, Jkt Utara, Daerah Khusus Ibukota Jakarta 14240',
      'latLng': const LatLng(-6.1575485,106.9083747),
      'eta': '25 mins (10.5 km)',
    },
    {
      'id': '3',
      'name': 'Lippo Mall Puri XXI',
      'address': 'Jl. Puri Indah Raya No.3 08, RT.3/RW.6, Kembangan Sel., Kec. Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11610',
      'latLng': const LatLng(-6.188375,106.7384395),
      'eta': '47 mins (38.0 km)',
    },
    {
      'id': '4',
      'name': 'Plaza Indonesia XXI',
      'address': 'Jl. M.H. Thamrin No.28 30, RT.9/RW.5, Gondangdia, Menteng, Central Jakarta City, Jakarta 10350',
      'latLng': const LatLng(-6.1929965, 106.8222255),
      'eta': '35 mins (28.9 km)',
    },
    {
      'id': '5',
      'name': 'Plaza Senayan XXI',
      'address': 'Plaza Senayan Lantai 5 Jl. Asia Afrika No. 8 Gelora Tanah Abang 1 3, RT.1/RW.3, Gelora, Kecamatan Tanah Abang, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10270',
      'latLng': const LatLng(-6.2253279, 106.8000611),
      'eta': '33 mins (28.0 km)',
    },
  ];

  Future<void> _openNavigation(LatLng destination) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition.latitude},${_currentPosition.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Cinema Locations',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF141414),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.farihah.swapicinema.swapi_cinema_app',
              ),
              MarkerLayer(
                markers: [
                  const Marker(
                    point: _currentPosition,
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  ..._cinemas.map((cinema) {
                    return Marker(
                      point: cinema['latLng'],
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 35,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 175,
              child: PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: _cinemas.length,
                onPageChanged: (index) {
                  final cinema = _cinemas[index];
                  _mapController.move(cinema['latLng'], 14.5);
                },
                itemBuilder: (context, index) {
                  final cinema = _cinemas[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cinema['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              cinema['address'],
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: Color(0xFFFFE81F),
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'ETA: ${cinema['eta']}',
                              style: const TextStyle(
                                color: Color(0xFFFFE81F),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 36,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFE81F),
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () {
                              _openNavigation(cinema['latLng']);
                            },
                            icon: const Icon(Icons.navigation, size: 14),
                            label: const Text(
                              'Get Directions',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
