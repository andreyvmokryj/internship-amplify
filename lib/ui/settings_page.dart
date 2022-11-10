import 'package:flutter/material.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/ui/shared_components/design_scaffold.dart';

import 'widgets/bottom_nav_bar.dart';
import 'settings_components/settings_list.dart';

class SettingsPage extends StatelessWidget {

  Widget build(BuildContext context) {

    return DesignScaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: AppSettingsList(),
      bottomNavigationBar: BottomNavBar()
    );
  }
}
