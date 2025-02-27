import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/cubits/locale_cubit.dart';
import '../../../../app/cubits/theme_cubit.dart';
import '../../../../app/routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String mapLocaleToString(Locale locale) {
    return locale.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return ListView(
            children: [
              if (authState is AuthLoaded) ...[
                ListTile(
                  leading: Icon(Icons.account_circle_outlined),
                  title: const Text('User Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    context.push('${Paths.userProfile}/${authState.auth.id}', extra: true);
                  },
                ),
                const Divider(),
              ],
              _buildThemeTile(context),
              const Divider(),
              _buildLanguageTile(context),
              const Divider(),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                  context.pushReplacement(Paths.login);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    final options = [ThemeCubit.lightThemeKey, ThemeCubit.darkThemeKey, ThemeCubit.customThemeKey];
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, theme) {
        final selectedTheme = ThemeCubit.themeToString(theme);
        return _buildOptionTile(
          title: 'Theme',
          icon: Icon(Icons.color_lens_outlined),
          selectedValue: selectedTheme,
          values: options,
          displayValues: options,
          onChanged: (value) {
            context.read<ThemeCubit>().toggleTheme(value!);
          },
        );
      },
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final selectedLanguage = mapLocaleToString(locale);
        return _buildOptionTile(
          title: 'Language',
          icon: Icon(Icons.language),
          selectedValue: selectedLanguage,
          values: ['en', 'vi'],
          displayValues: ['English', 'Tiếng Việt'],
          onChanged: (value) {
            context.read<LocaleCubit>().changeLocale(Locale(value!));
          },
        );
      },
    );
  }

  Widget _buildOptionTile({
    required String title,
    required Icon icon,
    required String? selectedValue,
    required List<String> values,
    required List<String> displayValues,
    required ValueChanged<String?>? onChanged,
  }) {
    return ListTile(
      title: Text(title),
      leading: icon,
      subtitle:
          selectedValue != null
              ? Text(_getDisplayValue(selectedValue, values, displayValues) ?? '')
              : null, // Display selected value
      trailing: const Icon(Icons.arrow_drop_down),
      onTap: () {
        _showDropdownDialog(title, selectedValue, values, displayValues, onChanged);
      },
    );
  }

  String? _getDisplayValue(String value, List<String> values, List<String> displayValues) {
    try {
      int index = values.indexOf(value);
      return displayValues[index];
    } catch (e) {
      return null;
    }
  }

  void _showDropdownDialog(
    String title,
    String? currentValue,
    List<String> values,
    List<String> displayValues,
    ValueChanged<String?>? onChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select $title"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(values.length, (index) {
                return ListTile(
                  title: Text(displayValues[index]),
                  onTap: () {
                    if (onChanged != null) {
                      onChanged(values[index]);
                      context.pop();
                    }
                  },
                  trailing: currentValue == values[index] ? Icon(Icons.check) : null,
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
