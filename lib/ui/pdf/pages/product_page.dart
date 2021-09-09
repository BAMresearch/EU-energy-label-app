/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/ui/pdf/bam_page.dart';
import 'package:energielabel_app/ui/pdf/components/product_entry_item.dart';
import 'package:pdf/widgets.dart';

class ProductPage extends StatelessMultiPage {
  ProductPage({
    required this.productData,
  });

  final Map<String, List<ProductFavorite>> productData;

  @override
  List<Widget> build() {
    return [
      for (final productCategory in productData.entries) ..._buildCategories(productCategory.key, productCategory.value)
    ];
  }

  List<Widget> _buildCategories(String categoryTitle, List<ProductFavorite> productItems) {
    return [
      _ProductHeader(categoryTitle),
      for (final product in productItems) ProductEntryItem(product),
    ];
  }
}

class _ProductHeader extends StatelessWidget {
  _ProductHeader(this.title);

  final String title;

  @override
  Widget build(Context context) {
    return Padding(
      padding: EdgeInsets.only(top: 28, bottom: 8),
      child: Text(title.toUpperCase(), style: Theme.of(context).header3),
    );
  }
}
