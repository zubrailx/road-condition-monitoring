import 'package:mobile/entities/configuration.dart';

abstract class ConfigurationGateway {
  Future<ConfigurationData?> getConfiguration();

  Future<bool> setConfiguration(ConfigurationData configuration);
}
