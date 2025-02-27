import 'package:flutter/material.dart';

import 'components.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _selectedTheme = 'light';
  String? _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Settings"),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: const Text('User Profile'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/view_profile');
            },
          ),
          const Divider(),
          _buildOptionTile(
            title: 'Theme',
            icon: Icon(Icons.color_lens_outlined), // Add appropriate icon
            selectedValue: _selectedTheme,
            values: ['light', 'dark', 'custom'],
            displayValues: ['Light', 'Dark', 'Custom 1'],
          ),
          const Divider(),
          _buildOptionTile(
            title: 'Language',
            icon: Icon(Icons.language), // Add appropriate icon
            selectedValue: _selectedLanguage,
            values: ['en', 'vi'],
            displayValues: ['English', 'Tiếng Việt'],
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required Icon icon,
    required String? selectedValue,
    required List<String> values,
    required List<String> displayValues,
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
        _showDropdownDialog(title, selectedValue, values, displayValues);
      },
    );
  }

  String? _getDisplayValue(String value, List<String> values, List<String> displayValues) {
    try {
      int index = values.indexOf(value);
      return displayValues[index];
    } catch (e) {
      return null; // Or a default display value
    }
  }

  void _showDropdownDialog(
    String title,
    String? currentValue,
    List<String> values,
    List<String> displayValues,
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
                    setState(() {
                      if (title == 'Theme') {
                        _selectedTheme = values[index];
                      } else if (title == 'Language') {
                        _selectedLanguage = values[index];
                      }
                    });
                    Navigator.pop(context); // Close the dialog
                    // Implement theme/language changing logic here
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
