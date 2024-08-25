class OnBoardingModel {
  final String asset;
  final String titel;
  final String subtitle;

  OnBoardingModel({
    required this.asset,
    required this.titel,
    required this.subtitle,
  });
}

List<OnBoardingModel> onBoardingItems = [
  OnBoardingModel(
    asset: 'assets/images/home1.svg',  
    titel: 'Quality',
    subtitle: 'Sell your farm fresh products directly to consumers, cutting out the middleman and reducing emissions of the global supply chain. ',
  ),
  OnBoardingModel(
    asset: 'assets/images/home2.svg',  
    titel: 'Convenient',
    subtitle: 'Our team of delivery drivers will make sure your orders are picked up on time and promptly delivered to your customers.',
  ),
  OnBoardingModel(
    asset: 'assets/images/home3.svg',  
    titel: 'Local',
    subtitle: 'We love the earth and know you do too! Join us in reducing our local carbon footprint one order at a time. ',
  ),
];
