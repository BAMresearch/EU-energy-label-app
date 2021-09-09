/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  News({this.title, this.description, this.language, this.publicationDate, this.markedRead});
  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'language')
  final String? language;

  @JsonKey(name: 'pubDate')
  final DateTime? publicationDate;

  final bool? markedRead;

  Map<String, dynamic> toJson() => _$NewsToJson(this);

  News copyWith({
    String? title,
    String? description,
    String? language,
    DateTime? publicationDate,
    bool? markedRead,
  }) {
    return News(
      title: title ?? this.title,
      description: description ?? this.description,
      language: language ?? this.language,
      publicationDate: publicationDate ?? this.publicationDate,
      markedRead: markedRead ?? this.markedRead,
    );
  }

  @override
  String toString() {
    return 'News{title: $title, description: $description, language: $language, publicationDate: $publicationDate, markedRead: $markedRead}';
  }
}
