import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/entities/configuration.dart';
import 'package:mobile/features/configuration.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class Configuration {
  const Configuration();
}

class ConfigurationLoading extends Configuration {
  const ConfigurationLoading();
}

class ConfigurationLoaded extends Configuration {
  final ConfigurationData configuration;

  const ConfigurationLoaded({required this.configuration});
}

class ConfigurationState with ChangeNotifier {
  late Configuration _configuration;
  bool _saved = false;

  ConfigurationState() {
    _configuration = const ConfigurationLoading();
    _init();
  }

  void _init() async {
    _configuration =
        ConfigurationLoaded(configuration: await getConfiguration());
    GetIt.I<Talker>().debug("Configuration loaded.");
    notifyListeners();
  }

  _save() async {
    if (_configuration.runtimeType == ConfigurationLoaded) {
      _saved = await saveConfiguration(
          (_configuration as ConfigurationLoaded).configuration);
      if (_saved) {
        GetIt.I<Talker>().debug("Configuration saved.");
      } else {
        GetIt.I<Talker>().error("Configuration is not saved.");
      }
      notifyListeners();
    }
  }

  bool get saved => _saved;

  Configuration get configuration => _configuration;

  ConfigurationData? get configurationData {
    if (configuration.runtimeType == ConfigurationLoaded) {
      return (configuration as ConfigurationLoaded).configuration;
    }
    return null;
  }

  setConfiguration(ConfigurationData configuration) {
    _configuration = ConfigurationLoaded(configuration: configuration);
    _save();
  }

  setUserAccount(UserAccountData userAccountData) {
    configurationData?.userAccountData = userAccountData;
    _save();
  }

  setSensorsEnabled(bool value) {
    configurationData?.sensorsEnabled = value;
    _save();
  }

  setNetworkEnabled(bool value) {
    configurationData?.networkEnabled = value;
    _save();
  }

  setChartAccelerometerEnabled(bool value) {
    configurationData?.chartAccelerometerEnabled = value;
    _save();
  }

  setChartGyroscopeEnabled(bool value) {
    configurationData?.chartGyroscopeEnabled = value;
    _save();
  }

  setChartGpsEnabled(bool value) {
    configurationData?.chartGpsEnabled = value;
    _save();
  }

  setChartWindowTimeSeconds(int value) {
    configurationData?.chartWindowTimeSeconds = value;
    _save();
  }

  setChartRefreshTimeMillis(int value) {
    configurationData?.chartRefreshTimeMillis = value;
    _save();
  }

  setNetworkApiURL(String value) {
    configurationData?.networkApiURL = value;
    _save();
  }

  setNetworkReceiverURL(String value) {
    configurationData?.networkReceiverURL = value;
    _save();
  }

  setNetworkBufferTimeSeconds(int value) {
    configurationData?.networkBufferTimeSeconds = value;
    _save();
  }

  setMapPointsBorderEnabled(bool value) {
    configurationData?.mapPointsBorderEnabled = value;
    _save();
  }

  setMapPointsSize(double value) {
    configurationData?.mapPointsSize = value;
    _save();
  }

  setGpsDistanceFilter(int value) {
    configurationData?.gpsDistanceFilter = value;
    _save();
  }

  setMapLocationEnabled(bool value) {
    configurationData?.mapLocationEnabled = value;
    _save();
  }
}
