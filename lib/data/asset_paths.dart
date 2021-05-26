/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:flutter/widgets.dart';

class AssetPaths {
  AssetPaths._();

  // Images
  static final String qrScanImage = 'assets/images/home/qr_scan.png';
  static final String quizImage = 'assets/images/home/quiz.png';
  static final String labelGuideImage = 'assets/images/label_guide.png';
  static final String newsCloseIcon = 'assets/images/home/ic_news_close_button.svg';

  static final String appIconImage = 'assets/images/infothek/appIcon.png';

  static final String checkedIcon = 'assets/images/ic_checked.svg';
  static final String uncheckedIcon = 'assets/images/ic_unchecked.svg';
  static final String shareIcon = 'assets/images/ic_share.svg';
  static final String externalLinkIcon = 'assets/images/external_link.svg';

  static final String drawerIcon = 'assets/images/home/ic_drawer.svg';
  static final String drawerCloseIcon = 'assets/images/home/ic_close.svg';

  static final String shieldIcon = 'assets/images/infothek/ic_licenses.svg';
  static final String contactMailIcon = 'assets/images/infothek/ic_contact_mail.svg';
  static final String contactPhoneIcon = 'assets/images/infothek/ic_contact_phone.svg';

  static final String menuFavoritesIcon = 'assets/images/menu/ic_menu_favorites.svg';
  static final String menuHomeIcon = 'assets/images/menu/ic_menu_home.svg';
  static final String menuKnowHowIcon = 'assets/images/menu/ic_menu_know_how.svg';
  static final String menuQrScanIcon = 'assets/images/menu/ic_menu_qr_scan.svg';
  static final String menuQuizIcon = 'assets/images/menu/ic_menu_quiz.svg';
  static final String menuFirstStepsIcon = 'assets/images/menu/ic_menu_first_steps.svg';

  static final String knowHowLightBulbIcon = 'assets/images/know_how/label_guide/ic_lightbulb.svg';

  static final String knowHowMenuWhyIsThereIcon = 'assets/images/know_how/ic_know_how_why_is_there.svg';
  static final String knowHowMenuGlossaryIcon = 'assets/images/know_how/ic_know_how_glossary.svg';
  static final String knowHowMenuRegulationsIcon = 'assets/images/know_how/ic_know_how_regulations.svg';

  static final String knowHowGlossaryClearIcon = 'assets/images/know_how/glossary/ic_clear.svg';

  static final String knowHowRegulationsPDFIcon = 'assets/images/know_how/regulations/ic_know_how_regulations_pdf.svg';

  static final String knowHowMenuChecklistIcon = 'assets/images/know_how/label_guide/ic_know_how_checklist.svg';
  static final String knowHowMenuTipsIcon = 'assets/images/know_how/label_guide/ic_know_how_tips.svg';
  static final String knowHowMenuFridgeGuideIcon = 'assets/images/know_how/label_guide/ic_know_how_fridge_guide.svg';

  static final String knowHowFridgeInfoZonesImage =
      'assets/images/know_how/label_guide/fridge_guide/fridge_info_zones.png';
  static final String knowHowFridgeInfoZonesRightImage =
      'assets/images/know_how/label_guide/fridge_guide/fridge_info_zones_right.png';
  static final String knowHowFridgeInfoZonesBubbleImage =
      'assets/images/know_how/label_guide/fridge_guide/fridge_info_zones_bubble.png';
  static final String knowHowFridgeInfoZonesSwitchSideBubbleImage =
      'assets/images/know_how/label_guide/fridge_guide/fridge_info_zones_switch_side_bubble.png';
  static final String knowHowFridgeInfoZonesTooltipCloseIcon =
      'assets/images/know_how/label_guide/fridge_guide/ic_guide_tooltip_close.png';

  static final String quizWrongAnswerIcon = 'assets/images/quiz/ic_wrong_answer.svg';
  static final String quizCorrectAnswerIcon = 'assets/images/quiz/ic_correct_answer.svg';
  static final String quizResultBackgroundImage = 'assets/images/quiz/quiz_result_background.svg';
  static final String quizResultCupSilverImage = 'assets/images/quiz/quiz_result_cup_silver.svg';
  static final String quizResultCupGoldImage = 'assets/images/quiz/quiz_result_cup_gold.svg';

  static final String favoriteEditIcon = 'assets/images/favorites/ic_edit.svg';
  static final String favoriteDeleteIcon = 'assets/images/favorites/ic_delete.svg';
  static final String favoriteSortIcon = 'assets/images/favorites/ic_sort.svg';

  static String labelGuideCategoryImage(String imageName) => 'assets/images/know_how/label_guide/$imageName';

  static String whyIsThereBackgroundImage(int index) =>
      'assets/images/know_how/why_is_there/whyisthere_bgr_shape_$index.png';
  static String whyIsThereFrontImage(String imageName) => 'assets/images/know_how/why_is_there/$imageName';

  static String onboardingFrontImage(int index) => 'assets/images/onboarding/onboarding_page_$index.png';
  static String onboardingBackgroundShape(int index) => 'assets/images/onboarding/onboarding_shape_$index.svg';

  // JSON
  static String glossaryJson(Locale locale) => 'assets/json/glossary_${locale.languageCode}.json';
  static String regulationDataJson(Locale locale) => 'assets/json/regulation_data_${locale.languageCode}.json';
  static String whyIsThereJson(Locale locale) => 'assets/json/why_is_there_${locale.languageCode}.json';
  static String labelGuideJson(Locale locale) => 'assets/json/label_guide_${locale.languageCode}.json';
  static String quizJson(Locale locale) => 'assets/json/quiz_${locale.languageCode}.json';

  // HTML
  static String imprintHtml(Locale locale) => 'assets/html/imprint_${locale.languageCode}.html';
  static String privacyPolicyHtml(Locale locale) => 'assets/html/privacy_policy_${locale.languageCode}.html';
}
