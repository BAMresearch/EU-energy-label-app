/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/ui/misc/pages/base_view_model.dart';
import 'package:flutter/widgets.dart';

/// Contract mixing for all app pages.
mixin BasePage on Widget {}

/// Base class for our stateless pages.
abstract class StatelessPage<T extends BaseViewModel> extends StatelessWidget with BasePage {
  const StatelessPage({Key? key}) : super(key: key);

  T createViewModel(BuildContext context);
}

/// Base class for our stateful pages.
abstract class StatefulPage extends StatefulWidget with BasePage {
  const StatefulPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return createPageState();
  }

  PageState createPageState();
}

/// Base state class for our stateful pages.
abstract class PageState<P extends StatefulPage, VM extends BaseViewModel> extends State<P> {
  VM createViewModel(BuildContext context);
}
