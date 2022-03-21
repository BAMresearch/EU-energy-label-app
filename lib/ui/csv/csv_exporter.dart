/* * Copyright 2020 Bundesanstalt für Materialforschung und -prüfung (BAM) *
* Licensed under the EUPL, Version 1.2 or – as soon they will be approved by the European Commission - subsequent versions of the EUPL (the "Licence");
* You may not use this work except in compliance with theLicence.
* You may obtain a copy of the Licence at:
* * https://joinup.ec.europa.eu/software/page/eupl *
* Unless required by applicable law or agreed to in writing, software distributed under the Licence is distributed on an "AS IS" basis,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the Licence for the specific language governing permissions and limitations under the Licence.*/

import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CsvExporter {
  CsvExporter({
    this.targetFileName = 'CSVExport.csv',
    required this.csvData,
  });

  final String targetFileName;
  final String csvData;

  Future<String> exportCsv() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();

    //export csv file
    final file = File(join(appDocDir.path, targetFileName));
    final Uint8List bytes = Uint8List.fromList(csvData.codeUnits);
    final File generatedPdfFile = await file.writeAsBytes(bytes);

    return generatedPdfFile.path;
  }
}
