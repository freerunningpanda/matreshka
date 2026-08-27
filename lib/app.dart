import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'features/battle_pass/presentation/screens/battle_pass_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battle Pass',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.screenBackground,
        fontFamily: 'Geologica',
      ),
      home: const BattlePassScreen(),
    );
  }
}
