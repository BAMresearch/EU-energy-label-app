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
  static const String qrScanImage = 'assets/images/home/qr_scan.png';
  static const String quizImage = 'assets/images/home/quiz.png';
  static const String labelGuideImage = 'assets/images/label_guide.png';
  static const String logoImage = 'assets/images/home/logo.svg';
  static const String logoBlackImage = 'assets/images/logo_black.svg';
  static const String newsCloseIcon = 'assets/images/home/ic_news_close_button.svg';

  static const String appIconImage = 'assets/images/infothek/appIcon.png';

  static const String checkedIcon = 'assets/images/ic_checked.svg';
  static const String uncheckedIcon = 'assets/images/ic_unchecked.svg';
  static const String shareIcon = 'assets/images/ic_share.svg';
  static const String externalLinkIcon = 'assets/images/external_link.svg';

  static const String drawerIcon = 'assets/images/home/ic_drawer.svg';
  static const String drawerCloseIcon = 'assets/images/home/ic_close.svg';

  static const String shieldIcon = 'assets/images/infothek/ic_licenses.svg';
  static const String contactMailIcon = 'assets/images/infothek/ic_contact_mail.svg';
  static const String contactPhoneIcon = 'assets/images/infothek/ic_contact_phone.svg';

  static const String menuFavoritesIcon = 'assets/images/menu/ic_menu_favorites.svg';
  static const String menuHomeIcon = 'assets/images/menu/ic_menu_home.svg';
  static const String menuKnowHowIcon = 'assets/images/menu/ic_menu_know_how.svg';
  static const String menuQrScanIcon = 'assets/images/menu/ic_menu_qr_scan.svg';
  static const String menuQuizIcon = 'assets/images/menu/ic_menu_quiz.svg';
  static const String menuFirstStepsIcon = 'assets/images/menu/ic_menu_first_steps.svg';

  static const String knowHowLightBulbIcon = 'assets/images/know_how/label_guide/ic_lightbulb.svg';
  static const String knowHowLightAdviserArrowUpIcon =
      'assets/images/know_how/label_guide/light_adviser/ic_arrows_up.svg';
  static const String knowHowLightAdviserArrowDownIcon =
      'assets/images/know_how/label_guide/light_adviser/ic_arrows_down.svg';
  static const String knowHowLightAdviserBackground =
      'assets/images/know_how/label_guide/light_adviser/light_adviser_background.svg';
  static const String knowHowLightAdviserIconsBasePath = 'assets/images/know_how/label_guide/light_adviser/';
  static const String knowHowLightAdviserBrightnessLevelIcon =
      'assets/images/know_how/label_guide/light_adviser/ic_brightness_level.svg';
  static const String knowHowLightAdviserTemperatureRoomIcon =
      'assets/images/know_how/label_guide/light_adviser/ic_temperature_room.svg';

  static const String knowHowMenuWhyIsThereIcon = 'assets/images/know_how/ic_know_how_why_is_there.svg';
  static const String knowHowMenuGlossaryIcon = 'assets/images/know_how/ic_know_how_glossary.svg';
  static const String knowHowMenuRegulationsIcon = 'assets/images/know_how/ic_know_how_regulations.svg';

  static const String knowHowGlossaryClearIcon = 'assets/images/know_how/glossary/ic_clear.svg';

  static const String knowHowRegulationsPDFIcon = 'assets/images/know_how/regulations/ic_know_how_regulations_pdf.svg';

  static const String knowHowMenuChecklistIcon = 'assets/images/know_how/label_guide/ic_know_how_checklist.svg';
  static const String knowHowMenuTipsIcon = 'assets/images/know_how/label_guide/ic_know_how_tips.svg';
  static const String knowHowMenuFridgeGuideIcon = 'assets/images/know_how/label_guide/ic_know_how_fridge_guide.svg';
  static const String knowHowMenuLightAdviserIcon = 'assets/images/know_how/label_guide/ic_know_how_light_adviser.svg';

  static const String knowHowFridgeInfoZonesImage =
      'assets/images/know_how/label_guide/fridge_guide/fridge_info_zones.png';
  static const String knowHowFridgeInfoZonesRightImage =
      'assets/images/know_how/label_guide/fridge_guide/fridge_info_zones_right.png';
  static const String knowHowFridgeInfoZonesBubbleImage =
      'assets/images/know_how/label_guide/fridge_guide/fridge_info_zones_bubble.png';
  static const String knowHowFridgeInfoZonesSwitchSideBubbleImage =
      'assets/images/know_how/label_guide/fridge_guide/fridge_info_zones_switch_side_bubble.png';
  static const String knowHowFridgeInfoZonesTooltipCloseIcon =
      'assets/images/know_how/label_guide/fridge_guide/ic_guide_tooltip_close.png';

  static const String quizWrongAnswerIcon = 'assets/images/quiz/ic_wrong_answer.svg';
  static const String quizCorrectAnswerIcon = 'assets/images/quiz/ic_correct_answer.svg';
  static const String quizResultBackgroundImage = 'assets/images/quiz/quiz_result_background.svg';
  static const String quizResultCupSilverImage = 'assets/images/quiz/quiz_result_cup_silver.svg';
  static const String quizResultCupGoldImage = 'assets/images/quiz/quiz_result_cup_gold.svg';

  static const String favoriteEditIcon = 'assets/images/favorites/ic_edit.svg';
  static const String favoriteDeleteIcon = 'assets/images/favorites/ic_delete.svg';
  static const String favoriteSortIcon = 'assets/images/favorites/ic_sort.svg';

  static String labelGuideCategoryImage(String? imageName) => 'assets/images/know_how/label_guide/$imageName';

  static String whyIsThereBackgroundImage(int index) =>
      'assets/images/know_how/why_is_there/whyisthere_bgr_shape_$index.png';

  static String whyIsThereFrontImage(String? imageName) => 'assets/images/know_how/why_is_there/$imageName';

  static String onboardingFrontImage(int index) => 'assets/images/onboarding/onboarding_page_$index.png';

  static String onboardingBackgroundShape(int index) => 'assets/images/onboarding/onboarding_shape_$index.svg';

  // JSON
  static String glossaryJson(Locale locale) => 'assets/json/glossary_${locale.languageCode}.json';

  static String regulationDataJson(Locale locale) => 'assets/json/regulation_data_${locale.languageCode}.json';

  static String whyIsThereJson(Locale locale) => 'assets/json/why_is_there_${locale.languageCode}.json';

  static String labelGuideJson(Locale locale) => 'assets/json/label_guide_${locale.languageCode}.json';

  static String quizJson(Locale locale) => 'assets/json/quiz_${locale.languageCode}.json';

  // HTML
  static String aboutBamHtml(Locale locale) => 'assets/html/about_bam_${locale.languageCode}.html';

  // Animations
  static const String loadingAnimationBinary = 'assets/animations/loading.riv';
}
