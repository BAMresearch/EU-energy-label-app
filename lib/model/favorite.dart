/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/scanner/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favorite.g.dart';

abstract class Favorite {}

@JsonSerializable()
class ProductFavorite extends Favorite {
  ProductFavorite({this.product, this.title, this.categoryId, List<String> comments = const []});

  factory ProductFavorite.fromJson(Map<String, dynamic> json) => _$ProductFavoriteFromJson(json);

  @JsonKey(name: 'product')
  final Product product;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'category_id')
  final int categoryId;

  @JsonKey(name: 'comments', defaultValue: [])
  List<String> comments;

  Map<String, dynamic> toJson() => _$ProductFavoriteToJson(this);

  ProductFavorite copyWith({
    Product product,
    String title,
    int categoryId,
    List<String> comments,
  }) {
    return ProductFavorite(
      product: product ?? this.product,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      comments: comments ?? this.comments,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductFavorite &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          title == other.title &&
          categoryId == other.categoryId &&
          comments == other.comments;

  @override
  int get hashCode => product.hashCode ^ title.hashCode ^ categoryId.hashCode ^ comments.hashCode;
}

@JsonSerializable()
class ChecklistFavorite extends Favorite {
  ChecklistFavorite({this.categoryId});

  factory ChecklistFavorite.fromJson(Map<String, dynamic> json) => _$ChecklistFavoriteFromJson(json);

  @JsonKey(name: 'category_id')
  final int categoryId;

  Map<String, dynamic> toJson() => _$ChecklistFavoriteToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChecklistFavorite && runtimeType == other.runtimeType && categoryId == other.categoryId;

  @override
  int get hashCode => categoryId.hashCode;
}

@JsonSerializable()
class CategoryTipsFavorite extends Favorite {
  CategoryTipsFavorite({this.categoryId});

  factory CategoryTipsFavorite.fromJson(Map<String, dynamic> json) => _$CategoryTipsFavoriteFromJson(json);

  @JsonKey(name: 'category_id')
  final int categoryId;

  Map<String, dynamic> toJson() => _$CategoryTipsFavoriteToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTipsFavorite && runtimeType == other.runtimeType && categoryId == other.categoryId;

  @override
  int get hashCode => categoryId.hashCode;
}
