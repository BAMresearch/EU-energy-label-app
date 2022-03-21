// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductFavorite _$ProductFavoriteFromJson(Map<String, dynamic> json) => ProductFavorite(
      product: json['product'] == null ? null : Product.fromJson(json['product'] as Map<String, dynamic>),
      title: json['title'] as String?,
      categoryId: json['category_id'] as int?,
      comments: (json['comments'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProductFavoriteToJson(ProductFavorite instance) => <String, dynamic>{
      'product': instance.product,
      'title': instance.title,
      'category_id': instance.categoryId,
      'comments': instance.comments,
    };

ChecklistFavorite _$ChecklistFavoriteFromJson(Map<String, dynamic> json) => ChecklistFavorite(
      categoryId: json['category_id'] as int?,
    );

Map<String, dynamic> _$ChecklistFavoriteToJson(ChecklistFavorite instance) => <String, dynamic>{
      'category_id': instance.categoryId,
    };

CategoryTipsFavorite _$CategoryTipsFavoriteFromJson(Map<String, dynamic> json) => CategoryTipsFavorite(
      categoryId: json['category_id'] as int?,
    );

Map<String, dynamic> _$CategoryTipsFavoriteToJson(CategoryTipsFavorite instance) => <String, dynamic>{
      'category_id': instance.categoryId,
    };
