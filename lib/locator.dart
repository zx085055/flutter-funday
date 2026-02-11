import 'package:flutter_funday/service/api_service.dart';
import 'package:flutter_funday/ui/widget/view_model/audio_guide_view_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<APIService>(() => APIService());

  locator.registerFactory<AudioGuideViewModel>(() => AudioGuideViewModel());
}
