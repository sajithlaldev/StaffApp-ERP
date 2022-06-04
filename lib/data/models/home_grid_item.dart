class HomeGridItem {
  String title;
  String icon;
  String? count;
  String? route;

  HomeGridItem({
    this.count,
    required this.icon,
    required this.title,
    this.route,
  });
}
