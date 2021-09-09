/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  Product({this.title, this.url});

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'url')
  final String? url;

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && title == other.title && url == other.url;

  @override
  int get hashCode => title.hashCode ^ url.hashCode;
}
