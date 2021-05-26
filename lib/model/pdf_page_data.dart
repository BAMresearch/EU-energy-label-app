import 'package:energielabel_app/model/favorite.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_checklist_data.dart';
import 'package:energielabel_app/model/know_how/label_guide/label_category_tip_data.dart';

abstract class PdfPageData {
  PdfPageData(this.pageCategory, this.titleProductCategory)
      : assert(pageCategory != null);

  final String pageCategory;
  final String titleProductCategory;
}

class ChecklistPdfPageData extends PdfPageData {
  ChecklistPdfPageData(
    String pageCategory,
    String titleProductCategory,
    this.checklistData,
  ) : super(pageCategory, titleProductCategory);

  final LabelCategoryChecklistData checklistData;
}

class TipsPdfPageData extends PdfPageData {
  TipsPdfPageData(
    String pageCategory,
    String titleProductCategory,
    this.tipsData,
  ) : super(pageCategory, titleProductCategory);

  final LabelCategoryTipData tipsData;
}

class ProductsPdfPageData extends PdfPageData {
  ProductsPdfPageData(
    String pageCategory,
    this.productData,
  ) : super(pageCategory, null);

  final Map<String, List<ProductFavorite>> productData;
}
