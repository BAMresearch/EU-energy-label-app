/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:convert';

import 'package:energielabel_app/model/home/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDao {
  NewsDao(SharedPreferences sharedPreferences) : _sharedPreferences = sharedPreferences;

  static const String _newsKey = 'news';

  final SharedPreferences _sharedPreferences;

  News? loadNews() {
    final jsonString = _sharedPreferences.getString(_newsKey);

    News? news;
    if (jsonString != null) {
      news = News.fromJson(jsonDecode(jsonString));
    }
    return news;
  }

  Future<void> saveNews(News news) async {
    await _sharedPreferences.setString(_newsKey, jsonEncode(news.toJson()));
  }
}
