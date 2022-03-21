/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'package:energielabel_app/data/asset_paths.dart';
import 'package:energielabel_app/ui/misc/pages/base_page.dart';
import 'package:energielabel_app/ui/misc/theme/bam_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart' as rive;

class SplashPage extends StatefulWidget with BasePage {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  rive.Artboard? _riveArtBoard;

  @override
  void initState() {
    super.initState();

    rootBundle.load(AssetPaths.loadingAnimationBinary).then((data) async {
      final file = rive.RiveFile.import(data);

      final artBoard = file.mainArtboard;
      final rive.RiveAnimationController controller = rive.SimpleAnimation('loading');
      artBoard.addController(controller);
      setState(() => _riveArtBoard = artBoard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: BamColorPalette.bamSplashGrayGradient,
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SvgPicture.asset(
                AssetPaths.logoImage,
                semanticsLabel: 'BAM Logo',
              ),

              // Loading animation
              if (_riveArtBoard != null)
                SizedBox(
                  height: 150,
                  width: 150,
                  child: rive.Rive(artboard: _riveArtBoard!),
                )
            ],
          ),
        ),
      ),
    );
  }
}
