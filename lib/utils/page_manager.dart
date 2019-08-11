import 'package:adibook/pages/add_pupil_section.dart';
import 'package:adibook/pages/event_list_section.dart';
import 'package:adibook/pages/message_list_section.dart';
import 'package:adibook/pages/more_list_section.dart';
import 'package:adibook/pages/pupil/ability_section.dart';
import 'package:adibook/pages/pupil/account_section.dart';
import 'package:adibook/pages/pupil/me_section.dart';
import 'package:adibook/pages/pupil/resources_section.dart';
import 'package:adibook/pages/pupil_list_section.dart';
import 'package:adibook/utils/constants.dart';
import 'package:flutter/material.dart';

class PageManager {
  List<WidgetConfiguration> get instructorWidgetsConfiguration {
    return this._widgetList.where((w) => w.availableFor == UserType.Instructor).toList();
  }

  List<WidgetConfiguration> get pupilWidgetsConfiguration {
    return this._widgetList.where((w) => w.availableFor == UserType.Pupil).toList();
  }

  List<WidgetConfiguration> getWidgetsConfigurationByUserType(UserType userType) {
    if (userType == UserType.Instructor)
      return this.instructorWidgetsConfiguration;
    if (userType == UserType.Pupil)
      return this.instructorWidgetsConfiguration;
    return [];
  }

  List<Widget> getWidgetsByUserType(UserType userType) {
    if (userType == UserType.Instructor)
      return this.instructorWidgetsConfiguration.map((f) => f.widget).toList();
    if (userType == UserType.Pupil)
      return this.instructorWidgetsConfiguration.map((f) => f.widget).toList();
    return [];
  }

  List<WidgetConfiguration> _widgetList = [
    WidgetConfiguration(
      index: 0,
      appBarTitle: 'Pupil',
      bottomNavTitle: 'Pupil',
      availableFor: UserType.Instructor,
      widget: PupilListSection(),
    ),
    WidgetConfiguration(
      index: 1,
      appBarTitle: 'Add Pupil',
      bottomNavTitle: 'Add Pupil',
      availableFor: UserType.Instructor,
      widget: AddPupilSection(),
    ),
    WidgetConfiguration(
      index: 2,
      appBarTitle: 'Diary',
      bottomNavTitle: 'Diary',
      availableFor: UserType.Instructor,
      widget: EventListSection(),
    ),
    WidgetConfiguration(
      index: 3,
      appBarTitle: 'Your Messages',
      bottomNavTitle: 'Messages',
      availableFor: UserType.Instructor,
      widget: MessageListSection(),
    ),
    WidgetConfiguration(
      index: 4,
      appBarTitle: 'More',
      bottomNavTitle: 'More',
      availableFor: UserType.Instructor,
      widget: MoreList(),
    ),
    WidgetConfiguration(
      index: 0,
      appBarTitle: 'Me',
      bottomNavTitle: 'Me',
      availableFor: UserType.Pupil,
      widget: MeSection(),
    ),
    WidgetConfiguration(
      index: 1,
      appBarTitle: 'Ability',
      bottomNavTitle: 'Ability',
      availableFor: UserType.Pupil,
      widget: AbilitySection(),
    ),
    WidgetConfiguration(
      index: 2,
      appBarTitle: 'Resources',
      bottomNavTitle: 'Resources',
      availableFor: UserType.Pupil,
      widget: ResourcesSection(),
    ),
    WidgetConfiguration(
      index: 3,
      appBarTitle: 'Account',
      bottomNavTitle: 'Account',
      availableFor: UserType.Pupil,
      widget: AccountSection(),
    ),
  ];
}

class WidgetConfiguration {
  WidgetConfiguration(
      {int index,
      String appBarTitle,
      String bottomNavTitle,
      UserType availableFor,
      Widget widget})
      : this.index = index,
        this.appBartitle = appBarTitle,
        this.bottomNavTitle = bottomNavTitle,
        this.availableFor = availableFor,
        this.widget = widget;
  int index;
  String appBartitle;
  String bottomNavTitle;
  UserType availableFor;
  Widget widget;
}
