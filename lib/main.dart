import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:template/features/customer/cart/cart_viewModel.dart';
import 'package:template/shared/app_size.dart';
import 'package:template/shared/localization/app_localization.dart';
import 'package:template/shared/notifications/local_notification.dart';
import 'package:template/shared/prefs/pref_manager.dart';
import 'package:template/shared/providers/language_provider.dart';
import 'package:template/shared/util/app_routes.dart';

import 'shared/notifications/firebase_notification.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefManager.init();
  print(PrefManager.currentUser?.token);
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.initCurrent(mediaQueryData: MediaQuery.of(context));
    return ScreenUtilInit(
      designSize: Size(AppSize.screenWidth, AppSize.screenHeight),
      builder: (_, i) => Consumer<LanguageProvider>(
        builder: (_, language, __) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          locale: language.appLocale,
          onGenerateRoute: AppRoutes.appRoutes,
          initialRoute: AppRoutes.splashScreen,
        ),
      ),
    );
  }
}
