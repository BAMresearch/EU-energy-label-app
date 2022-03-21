/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/ui/favorites/pages/favorite_type.dart';

abstract class FavoriteListItem {
  FavoriteListItem({
    required this.title,
    required this.favoriteType,
    this.comments,
  });

  final String title;
  final List<String>? comments;
  final FavoriteType favoriteType;
}

class FavoriteListSection extends FavoriteListItem {
  FavoriteListSection({
    required String title,
    required FavoriteType favoriteType,
    required this.sectionEntries,
    this.productCategory,
  }) : super(title: title, favoriteType: favoriteType);

  final List<FavoriteListSectionEntry> sectionEntries;
  final int? productCategory;
}

class FavoriteListSectionEntry<T extends Favorite> extends FavoriteListItem {
  FavoriteListSectionEntry({
    required String title,
    required FavoriteType favoriteType,
    required this.favorite,
    comments,
  }) : super(title: title, favoriteType: favoriteType, comments: comments);

  final T favorite;
}
