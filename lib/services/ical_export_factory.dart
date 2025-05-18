import 'ical_export_service.dart';
import 'ical_export_service_mobile.dart'
    if (dart.library.io) 'ical_export_service_mobile.dart';
import 'ical_export_service_web.dart'
    if (dart.library.html) 'ical_export_service_web.dart';

/// Factory function to create an instance of [ICalExportService].
/// It checks the platform at runtime and returns the appropriate implementation.
ICalExportService createICalExportService() {
  if (const bool.fromEnvironment('dart.library.html', defaultValue: false)) {
    return ICalExportServiceWeb();
  }

  if (const bool.fromEnvironment('dart.library.io', defaultValue: false)) {
    return ICalExportServiceMobile();
  }
  throw UnsupportedError('Platform not supported for ICalExportService');
}
