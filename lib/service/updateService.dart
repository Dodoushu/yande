import 'dart:async';
import 'dart:io';
import 'settingService.dart';
import 'package:yande/model/all_model.dart';
import 'API/all_api.dart';
import 'package:package_info/package_info.dart';
import 'package:dio/dio.dart';

typedef ShouldUpdateCallback = void Function(GithubReleaseModel);

class UpdateService {
  static Future<void> getVersion({ShouldUpdateCallback shouldUpdate}) async {
    Dio dio = new Dio();
    Response<dynamic> res =await dio.get(GithubApi.latestApi);
    GithubReleaseModel githubReleaseModel
      = GithubReleaseModel.fromJson(Map.from(res.data));
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    SettingItem item =await SettingService.getSetting(UpdateValue.ignoreVersion);
    print(item.value);
    if (githubReleaseModel.tagName != item.value &&
        packageInfo.version != githubReleaseModel.tagName) {
      shouldUpdate(githubReleaseModel);
    }

  }

  static Future<void> ignoreUpdateVersion(String version) async{
    await SettingService.saveSetting(new SettingItem(
      name: UpdateValue.ignoreVersion,
      value: version,
    ));
  }
}

class UpdateValue {
  static const String ignoreVersion = 'ignoreVersion';
}