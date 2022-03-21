# EU energy label app

[Flutter](https://flutter.dev) based app project for finding energy and environmental information on products carrying the new European energy label. Current version see [CHANGELOG](CHANCELOG.md).

This repo provides a quick start for mobile app development and consists of a fully functional app for iOS and Android which can be tailored to your needs.

## App features
**NEW EU ENERGY LABEL**
This app is all about the EU energy labelt hat has guided consumers since more than 20 years, giving information about efficient washing machines, TVs, lamps etc.. Starting March 2021, a new version of the label will be in shops. Learn how the new lables work and how you can benefit as a consumer..

**HINTS FOR BUYING APPLIANCES**
Do you plan to buy a new appliance? The app’s label guide gives you checklists to help you choose from the available products. Hints for everyday efficiency help you protect the environment and save money when using these products.

**QR SCAN**
The new labels have a QR code than can be scanned using the app. It leads you to additional information about the labeled product, like its efficiency class, resource consumption and other details.

**QUIZ**
Play the quiz to test your knowledge about energy efficiency at home! You can learn about many of the concepts and terms behind energy efficiency by checking out the wiki.

**FOR DEALERS**
As a dealer of energy using products, you can use the app to help your customers find out more about the products you are offering. All efficiency details at a glance from an official EU database, without the need for manufacturer-specific sites, catalogues or flyers.

## Useful Links

- [Energy label App by BAM](https://netzwerke.bam.de/Netzwerke/Content/DE/Standardartikel/Evpg/Evpg-Links/energielabel_app.html) (in German only)
- [AppStore: Energy label app](https://apps.apple.com/de/app/energielabel/id1543159006)
- [PlayStore: Energy label app](https://play.google.com/store/apps/details?id=de.bam.energielabelapp)
- [EPREL - European Product Registry for Energy Labelling](https://eprel.ec.europa.eu/)

## Requirements

Required Software:
- Android Studio
- Flutter SDK

## Recommendations
- FVM to choose the correct Flutter Version

For help getting started with Flutter, view the [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

## Configuration
The App need some arguments. There are 3 different run configurations which passes the right arguments.
Each configuration stands for the linked backend.

- dev
- staging
- prod

The needed arguments are:
- --dart-define=ENVIRONMENT=**[dev|staging|prod]**
- --dart-define=BACKEND_URL=**theBackendURL**
- --dart-define=API_KEY=**anAPIKey**

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[EUPL 1.2](https://joinup.ec.europa.eu/sites/default/files/custom-page/attachment/2020-03/EUPL-1.2%20EN.txt)

## Credits and references
The Bundesanstalt für Materialforschung und -prüfung (BAM) is a senior scientific and technical Federal institute with responsibility to the Federal Ministry for Economic Affairs and Energy. It tests, researches, and advises to protect people, the environment and material goods.
For more information visit our website [BAM](https://www.bam.de/Navigation/EN/Home/home.html)
