/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/regulation_data_repository.dart';
import 'package:energielabel_app/service_locator.dart';
import 'package:energielabel_app/ui/know_how/components/regulations/regulations_card_view.dart';
import 'package:energielabel_app/ui/know_how/pages/regulations/regulations_view_model.dart';
import 'package:energielabel_app/ui/misc/components/error_view.dart';
import 'package:energielabel_app/ui/misc/page_scaffold.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/pages/view_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegulationsPage extends StatelessPage<RegulationsViewModel> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegulationsViewModel>(
      create: (context) => createViewModel(context)..onViewStarted(),
      child: Consumer<RegulationsViewModel>(builder: (context, viewModel, _) {
        return PageScaffold(
          title: viewModel.pageTitle,
          body: Builder(builder: (context) {
            switch (viewModel.viewState) {
              case ViewState.initialized:
                return _buildInitializedState(context, viewModel);
              case ViewState.error:
                return _buildErrorState();
              default:
                return SizedBox.shrink();
            }
          }),
        );
      }),
    );
  }

  @override
  RegulationsViewModel createViewModel(BuildContext context) {
    return RegulationsViewModel(
      context: context,
      regulationDataRepository: ServiceLocator().get<RegulationDataRepository>()!,
    );
  }

  Widget _buildInitializedState(BuildContext context, RegulationsViewModel viewModel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              viewModel.pageDescription!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),

          for (final regulation in viewModel.regulations)
            RegulationsCardView(regulation: regulation, viewModel: viewModel),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return ErrorView();
  }
}
