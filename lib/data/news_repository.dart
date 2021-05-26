/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/api/bam_api_client.dart';
import 'package:energielabel_app/data/persistence/news_dao.dart';
import 'package:energielabel_app/data/repository_exception.dart';
import 'package:energielabel_app/device_info.dart';
import 'package:energielabel_app/model/home/news.dart';
import 'package:energielabel_app/utils/optional_extensions.dart';
import 'package:optional/optional.dart';

class NewsRepository {
  NewsRepository(NewsDao newsDao, BamApiClient apiClient, DeviceInfo deviceInfo)
      : assert(newsDao != null),
        assert(apiClient != null),
        assert(deviceInfo != null),
        _newsDao = newsDao,
        _apiClient = apiClient,
        _deviceInfo = deviceInfo;

  final NewsDao _newsDao;
  final BamApiClient _apiClient;
  final DeviceInfo _deviceInfo;

  Future<void> saveNews(News news) async {
    try {
      await _newsDao.saveNews(news);
    } catch (e) {
      throw RepositoryException('Failed to save news.', e);
    }
  }

  Optional<News> loadNews() {
    try {
      return _newsDao.loadNews();
    } catch (e) {
      throw RepositoryException('Failed to load news.', e);
    }
  }

  Future<void> syncNews() async {
    try {
      final fetchedNews = await _apiClient.fetchNews(_deviceInfo.bestMatchedLocale.languageCode);
      if (fetchedNews.isPresent) {
        final storedNews = loadNews();

        if (storedNews.isNotPresent || fetchedNews.value.publicationDate.isAfter(storedNews.value.publicationDate)) {
          await saveNews(fetchedNews.value.copyWith(markedRead: false));
        }
      }
    } catch (e) {
      throw RepositoryException('Failed to synchronize news.', e);
    }
  }
}
