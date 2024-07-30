import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/Providers/theme_provider.dart';

class themeScreen extends StatefulWidget {
  const themeScreen({super.key});

  @override
  State<themeScreen> createState() => _themeScreenState();
}

class _themeScreenState extends State<themeScreen> {
  @override
  Widget build(BuildContext context) {
    final _themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme"),
      ),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: const Text("Dark Mode"),
            value: ThemeMode.dark,
            groupValue: _themeChanger.themeMode,
            onChanged: _themeChanger.setTheme,
          ),
          RadioListTile<ThemeMode>(
            title: const Text("light Mode"),
            value: ThemeMode.light,
            groupValue: _themeChanger.themeMode,
            onChanged: _themeChanger.setTheme,
          ),
          RadioListTile<ThemeMode>(
            title: const Text("System Default"),
            value: ThemeMode.system,
            groupValue: _themeChanger.themeMode,
            onChanged: _themeChanger.setTheme,
          )
        ],
      ),
    );
  }
}
