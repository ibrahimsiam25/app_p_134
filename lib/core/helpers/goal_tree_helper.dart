import '../constants/assets.dart';

class GoalTreeHelper {
  static String getTreeImageForPercent(double percent) {
    if (percent <= 0) {
      return Assets.imagesGoalNotAchieved;
    } else if (percent <= 20) {
      return Assets.imagesGoalInitalAchieved;
    } else if (percent <= 40) {
      return Assets.imagesGoalAchieved1;
    } else if (percent <= 60) {
      return Assets.imagesGoalAchieved2;
    } else if (percent <= 80) {
      return Assets.imagesGoalAchieved3;
    } else if (percent < 100) {
      return Assets.imagesGoalAchieved4;
    } else {
      return Assets.imagesGoalAchieved5;
    }
  }
}
