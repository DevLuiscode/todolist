import 'package:flutter/material.dart';

import 'package:gestordeventas/ui/home_screen.dart';
import 'package:gestordeventas/ui/provider/group_provider.dart';
import 'package:gestordeventas/ui/provider/task_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GroupProvider(),
        ),
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.indigo,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
