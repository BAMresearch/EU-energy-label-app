/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/api/bam_api_client.dart';
import 'package:energielabel_app/data/favorite_repository.dart';
import 'package:energielabel_app/data/glossary_repository.dart';
import 'package:energielabel_app/data/label_guide_repository.dart';
import 'package:energielabel_app/data/news_repository.dart';
import 'package:energielabel_app/data/persistence/favorite_dao.dart';
import 'package:energielabel_app/data/persistence/label_guide_dao.dart';
import 'package:energielabel_app/data/persistence/news_dao.dart';
import 'package:energielabel_app/data/persistence/quiz_dao.dart';
import 'package:energielabel_app/data/quiz_repository.dart';
import 'package:energielabel_app/data/regulation_data_repository.dart';
import 'package:energielabel_app/data/settings_repository.dart';
import 'package:energielabel_app/data/why_is_there_repository.dart';
import 'package:energielabel_app/device_info.dart';
import 'package:energielabel_app/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Convenience wrapper around GetIt.
class ServiceLocator {
  factory ServiceLocator() => _instance ??= ServiceLocator._();

  ServiceLocator._();

  static ServiceLocator? _instance;

  Future<void> registerDependencies(BuildContext context) async {
    final preferences = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();

    GetIt.I.registerSingleton<AssetBundle>(DefaultAssetBundle.of(context));
    GetIt.I.registerLazySingleton(() => DeviceInfo(Translations.supportedLocales));
    GetIt.I.registerLazySingleton(() => packageInfo);

    // API
    GetIt.I.registerLazySingleton(() => BamApiClient(baseUrl: AppConfig.backendURL, apiKey: AppConfig.apiKey));

    // DAOs
    GetIt.I.registerLazySingleton(() => QuizDao(preferences));
    GetIt.I.registerLazySingleton(() => NewsDao(preferences));
    GetIt.I.registerLazySingleton(() => LabelGuideDao(preferences));
    GetIt.I.registerLazySingleton(() => FavoriteDao(preferences));

    // Repositories
    GetIt.I.registerLazySingleton(() => SettingsRepository(preferences));
    GetIt.I.registerLazySingleton(() => WhyIsThereRepository(get<AssetBundle>()!, get<DeviceInfo>()!));
    GetIt.I.registerLazySingleton(
        () => LabelGuideRepository(get<AssetBundle>()!, get<DeviceInfo>()!, get<LabelGuideDao>()));
    GetIt.I.registerLazySingleton(() => GlossaryRepository(get<AssetBundle>()!, get<DeviceInfo>()!));
    GetIt.I.registerLazySingleton(() => RegulationDataRepository(get<AssetBundle>()!, get<DeviceInfo>()!));
    GetIt.I.registerLazySingleton(() => NewsRepository(get<NewsDao>()!, get<BamApiClient>()!, get<DeviceInfo>()!));
    GetIt.I.registerLazySingleton(() => QuizRepository(
        get<SettingsRepository>()!, get<QuizDao>()!, get<BamApiClient>()!, get<AssetBundle>()!, get<DeviceInfo>()!));
    GetIt.I.registerLazySingleton(() => FavoriteRepository(get<FavoriteDao>()!));

    return GetIt.I.allReady();
  }

  T? call<T extends Object>() => GetIt.I.call<T>();

  T? get<T extends Object>() => GetIt.I.get<T>();
}
