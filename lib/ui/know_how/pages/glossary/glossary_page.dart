/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/data/glossary_repository.dart';
import 'package:energielabel_app/model/know_how/glossary/glossary_entry.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/know_how/pages/glossary/glossary_view_model.dart';
import 'package:energielabel_app/ui/misc/components/error_view.dart';
import 'package:energielabel_app/ui/misc/html_utils.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/pages/view_state.dart';
import 'package:energielabel_app/ui/misc/text_span_utils.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class GlossaryPage extends StatefulPage {
  const GlossaryPage({Key? key, this.initialSearchText}) : super(key: key);

  final String? initialSearchText;

  @override
  _GlossaryPageState createPageState() => _GlossaryPageState();
}

class _GlossaryPageState extends PageState<GlossaryPage, GlossaryViewModel> {
  final TextEditingController _searchFieldController = TextEditingController();
  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();

    _searchFieldController.text = widget.initialSearchText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: Translations.of(context)!.glossary_page_title,
      titleSemanticLabel: Translations.of(context)!.glossary_page_title_semantic,
      body: _buildBody(),
    );
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    return ChangeNotifierProvider<GlossaryViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<GlossaryViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFilterField(viewModel),
              Expanded(
                child: Builder(
                  builder: (context) {
                    switch (viewModel.viewState) {
                      case ViewState.initializing:
                        return _buildProgressState();
                      case ViewState.initialized:
                        return _buildGlossaryList(viewModel);
                      case ViewState.error:
                        return _buildErrorState();
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  GlossaryViewModel createViewModel(BuildContext context) {
    return GlossaryViewModel(
        glossaryRepository: ServiceLocator().get<GlossaryRepository>()!, initialFilterInput: widget.initialSearchText);
  }

  Widget _buildFilterField(GlossaryViewModel viewModel) {
    return Material(
      elevation: 1,
      child: Container(
        height: 72,
        color: BamColorPalette.bamWhite,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: TextField(
          autofocus: false,
          controller: _searchFieldController,
          onChanged: viewModel.onFilterInputChanged,
          cursorColor: Theme.of(context).colorScheme.secondary,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: Translations.of(context)!.glossary_page_search_hint,
            hintStyle: Theme.of(context).textTheme.bodyText2,
            icon: Icon(
              Icons.search,
              color: Theme.of(context).iconTheme.color,
              size: 24,
            ),
            suffixIcon: _searchFieldController.text.isNotEmpty
                ? Semantics(
                    label: Translations.of(context)!.glossary_page_search_clear_button_semantics,
                    onTap: () => _clearFilterField(viewModel),
                    button: true,
                    excludeSemantics: true,
                    child: GestureDetector(
                      onTap: () => _clearFilterField(viewModel),
                      child: SvgPicture.asset(AssetPaths.knowHowGlossaryClearIcon, fit: BoxFit.scaleDown),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  void _clearFilterField(GlossaryViewModel viewModel) {
    _searchFieldController.clear();
    viewModel.onFilterInputChanged('');
  }

  Widget _buildProgressState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildGlossaryList(GlossaryViewModel viewModel) {
    if (viewModel.glossaryEntries.isNotEmpty) {
      return ScrollablePositionedList.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) =>
            _buildGlossaryEntry(viewModel.glossaryEntries[index]!, viewModel.filterInput, viewModel),
        separatorBuilder: (context, index) => const SizedBox(height: 32),
        itemCount: viewModel.glossaryEntries.length,
        itemScrollController: _itemScrollController,
        initialScrollIndex: viewModel.initialSelectedGlossaryEntry,
      );
    } else {
      return Center(
        child: Text(Translations.of(context)!.glossary_page_search_no_matches),
      );
    }
  }

  Widget _buildGlossaryEntry(GlossaryEntry glossaryEntry, String filterInput, GlossaryViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          RichText(
            text: TextSpanExtension.searchMatch(
              glossaryEntry.title,
              filterInput,
              negativeResultTextStyle: Theme.of(context).textTheme.headline3!.copyWith(color: BamColorPalette.bamBlue3),
              positiveResultTextStyle: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Theme.of(context).iconTheme.color,
                  ),
            ),
          ),

          const SizedBox(height: 8),

          // Content

          HtmlUtils.stringToHtml(context, viewModel.highlightString(glossaryEntry.description),
              customStyle: {'span': Style(color: Theme.of(context).iconTheme.color)})
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return const ErrorView();
  }
}
