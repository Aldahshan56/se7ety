class OnBoardingModel {
  final String title;
  final String description;
  final String image;

  OnBoardingModel(
      {required this.title, required this.description, required this.image});
}

List<OnBoardingModel> onBoardingPages = [
  OnBoardingModel(
      image: 'assets/images/on1.svg',
      title: 'ابحث عن دكتور متخصص',
      description:
      'اكتشف مجموعة واسعة من الأطباء الخبراء والمتخصصين في مختلف المجالات.'),
  OnBoardingModel(
      image: 'assets/images/on2.svg',
      title: 'سهولة الحجز',
      description: 'احجز المواعيد بضغطة زرار في أي وقت وفي أي مكان.'),
  OnBoardingModel(
      image: 'assets/images/on3.svg',
      title: 'آمن وسري',
      description: 'كن مطمئنًا لأن خصوصيتك وأمانك هما أهم أولوياتنا.')
];