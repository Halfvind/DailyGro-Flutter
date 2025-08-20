import 'package:get/get.dart';

class LocationService extends GetxService {
  final _currentLocation = Rxn<Map<String, double>>();
  
  Map<String, double>? get currentLocation => _currentLocation.value;
  
  Future<LocationService> init() async {
    // Initialize location service
    return this;
  }
  
  Future<Map<String, double>?> getCurrentLocation() async {
    // Mock location for now
    final location = {
      'latitude': 37.7749,
      'longitude': -122.4194,
    };
    _currentLocation.value = location;
    return location;
  }
  
  Future<double> calculateDistance(
    double startLat, 
    double startLng, 
    double endLat, 
    double endLng,
  ) async {
    // Mock distance calculation
    return 5.2; // km
  }
  
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    // Mock reverse geocoding
    return '123 Main St, City, State';
  }
}