import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';
import 'package:radency_internship_project_2/utils/ui_utils.dart';
import 'package:radency_internship_project_2/blocs/settings/settings_bloc.dart';
import 'package:radency_internship_project_2/utils/routes.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:radency_internship_project_2/generated/l10n.dart';


class AppSettingsList extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (BuildContext context, state) {
      return Container(
          child: SettingsList(
        backgroundColor: Colors.white,
        sections: [
          SettingsSection(
            titleTextStyle: TextStyle(color: Colors.grey),

            tiles: [
              SettingsTile(
                title: S.of(context).main_currency,
                subtitle: state.currency,
                leading: Icon(FontAwesome5Solid.money_bill),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, Routes.currencySettingPage);
                },
              ),
              SettingsTile(
                title: S.of(context).language,
                subtitle: state.language,
                leading: Icon(FontAwesome5Solid.language),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, Routes.languageSettingPage);
                },
              ),
              SettingsTile(
                title: S.of(context).style,
                leading: Icon(FontAwesome5Solid.palette),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, Routes.styleSettingPage);
                },
              ),
              SettingsTile(
                title: S.current.incomeCategoryTitle,
                leading: Icon(FontAwesome5Solid.money_bill),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, Routes.incomeCategoriesPage);
                },
              ),
              SettingsTile(
                title: S.current.expensesCategoryTitle,
                leading: Icon(FontAwesome5Solid.money_bill_wave),
                onPressed: (BuildContext context) {
                  Navigator.pushNamed(context, Routes.expensesCategoriesPage);
                },
              ),
            ],
          ),
        ],
      ));
    });
  }
}
