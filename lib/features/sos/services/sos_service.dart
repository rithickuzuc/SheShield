// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SosService {
//   /// Gets the user's current location.
//   Future<Position> getCurrentLocation() async {
//     final serviceEnabled =
//         await Geolocator.isLocationServiceEnabled();

//     if (!serviceEnabled) {
//       throw Exception(
//         "Location services are disabled.",
//       );
//     }

//     LocationPermission permission =
//         await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission =
//           await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.denied) {
//       throw Exception(
//         "Location permission was denied.",
//       );
//     }

//     if (permission ==
//         LocationPermission.deniedForever) {
//       throw Exception(
//         "Location permission is permanently denied.",
//       );
//     }

//     return await Geolocator.getCurrentPosition(
//       locationSettings:
//           const LocationSettings(
//         accuracy: LocationAccuracy.high,
//       ),
//     );
//   }

//   /// Creates a Google Maps link from coordinates.
//   String createLocationLink(
//     Position position,
//   ) {
//     return "https://www.google.com/maps/search/?api=1"
//         "&query=${position.latitude},${position.longitude}";
//   }

//   /// Opens the phone dialer.
//   Future<void> callEmergencyNumber(
//     String phoneNumber,
//   ) async {
//     final Uri phoneUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );

//     if (await canLaunchUrl(phoneUri)) {
//       await launchUrl(phoneUri);
//     } else {
//       throw Exception(
//         "Unable to open phone application.",
//       );
//     }
//   }

//   /// Opens the SMS composer with a pre-filled emergency message.
//   Future<void> sendEmergencySms({
//     required String phoneNumber,
//     required String message,
//   }) async {
//     final Uri smsUri = Uri(
//       scheme: 'sms',
//       path: phoneNumber,
//       queryParameters: {
//         'body': message,
//       },
//     );

//     if (await canLaunchUrl(smsUri)) {
//       await launchUrl(smsUri);
//     } else {
//       throw Exception(
//         "Unable to open SMS application.",
//       );
//     }
//   }
// }
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SosService {
  Future<Position> getCurrentLocation() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        "Location services are disabled.",
      );
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        "Location permission was denied.",
      );
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception(
        "Location permission is permanently denied. Please enable it from Settings.",
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  String createLocationLink(
    Position position,
  ) {
    return "https://www.google.com/maps/search/?api=1"
        "&query=${position.latitude},${position.longitude}";
  }

  String createEmergencyMessage({
    required String locationLink,
  }) {
    return """
🚨 SheShield Emergency Alert

I need help. My emergency SOS has been activated.

📍 My current location:
$locationLink

Please contact me immediately and take appropriate action.

— SheShield
""";
  }

  Future<void> openSms({
    required String phoneNumber,
    required String message,
  }) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {
        'body': message,
      },
    );

    final launched = await launchUrl(smsUri);

    if (!launched) {
      throw Exception(
        "Unable to open the messaging application.",
      );
    }
  }

  Future<void> callGuardian(
    String phoneNumber,
  ) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    final launched = await launchUrl(phoneUri);

    if (!launched) {
      throw Exception(
        "Unable to open the phone application.",
      );
    }
  }
}