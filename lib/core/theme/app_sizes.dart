/// Числовые размеры (width/height) виджетов presentation-слоя
/// (features/**/presentation) — вместо разбросанных по коду литералов вида
/// `width: 96, height: 96`.
///
/// Именование: horizontalSize{N} — значение для `width:`, verticalSize{N} —
/// для `height:`, allSize{N} — для случая, когда у одного виджета
/// `width:` и `height:` равны N (квадратная плитка/иконка), общее
/// значение для обоих параметров.
///
/// Не включает: TextStyle.height (это множитель межстрочного интервала, а
/// не размер в пикселях), Border.all(width:) (толщина обводки), spacer-
/// SizedBox без child (см. AppSizedBoxes), координаты Positioned.
abstract final class AppSizes {
  // Horizontal (width)
  static const horizontalSize12 = 12.0;
  static const horizontalSize26 = 26.0;
  static const horizontalSize27 = 27.0;
  static const horizontalSize30 = 30.0;
  static const horizontalSize40 = 40.0;
  static const horizontalSize44 = 44.0;
  static const horizontalSize48 = 48.0;
  static const horizontalSize54 = 54.0;
  static const horizontalSize69 = 69.0;
  static const horizontalSize100 = 100.0;
  static const horizontalSize112 = 112.0;
  static const horizontalSize214 = 214.0;
  static const horizontalSize242 = 242.0;
  static const horizontalSize295 = 295.0;
  static const horizontalSize320 = 320.0;
  static const horizontalSize324 = 324.0;
  static const horizontalSize400 = 400.0;
  static const horizontalSize439 = 439.0;
  static const horizontalSize600 = 600.0;
  static const horizontalSize626 = 626.0;
  static const horizontalSize668 = 668.0;

  // Vertical (height)
  static const verticalSize8 = 8.0;
  static const verticalSize14 = 14.0;
  static const verticalSize20 = 20.0;
  static const verticalSize22 = 22.0;
  static const verticalSize26 = 26.0;
  static const verticalSize34 = 34.0;
  static const verticalSize36 = 36.0;
  static const verticalSize39 = 39.0;
  static const verticalSize46 = 46.0;
  static const verticalSize52 = 52.0;
  static const verticalSize56 = 56.0;
  static const verticalSize60 = 60.0;
  static const verticalSize100 = 100.0;
  static const verticalSize110 = 110.0;
  static const verticalSize184 = 184.0;
  static const verticalSize240 = 240.0;
  static const verticalSize300 = 300.0;
  static const verticalSize550 = 550.0;
  static const verticalSize1304 = 1304.0;

  // All (width == height, квадрат)
  static const allSize18 = 18.0;
  static const allSize30 = 30.0;
  static const allSize34 = 34.0;
  static const allSize36 = 36.0;
  static const allSize84 = 84.0;
  static const allSize96 = 96.0;
  static const allSize100 = 100.0;
}
