import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermissions(
      [String from = 'settings']) async {
    try {
      if (Platform.isIOS) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      } else {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      if (from == 'settings') {
        await AppSettings.openAppSettings();
      }

      emit(state.copyWith(status: SettingsStatus.permissionGranted));
    } catch (e) {
      emit(state.copyWith(
          status: SettingsStatus.error,
          message: 'Failed to request notification permissions: $e'));
    }
  }

  Future<void> launchPrivacyPolicy() async {
    try {
      await launchUrlString('https://www.google.com');
      emit(state.copyWith(status: SettingsStatus.privacyPolicyOpened));
    } catch (e) {
      emit(state.copyWith(
          status: SettingsStatus.error,
          message: 'Failed to launch privacy policy: $e'));
    }
  }

  Future<void> shareApp() async {
    try {
      
      emit(state.copyWith(status: SettingsStatus.appShared));
    } catch (e) {
      emit(state.copyWith(
          status: SettingsStatus.error, message: 'Failed to share app: $e'));
    }
  }
}
