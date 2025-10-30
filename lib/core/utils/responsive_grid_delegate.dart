class ResponsiveGridDelegate {
  static bool isList(double width) => width < 600;

  static bool isTablet(double width) => width >= 600 && width < 1024;

  static bool isDesktop(double width) => width >= 1024;

  static int columnsForWidth(double width) {
    if (isDesktop(width)) return 4;
    if (isTablet(width)) return 2;
    return 1;
  }
}
