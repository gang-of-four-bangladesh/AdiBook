import 'package:adibook/pages/instructor/add_pupil_section.dart';
import 'package:adibook/pages/instructor/event_list_section.dart';
import 'package:adibook/pages/instructor/message_list_section.dart';
import 'package:adibook/pages/instructor/more_list_section.dart';
import 'package:adibook/pages/instructor/pupil_list_section.dart';
import 'package:adibook/pages/pupil/ability_section.dart';
import 'package:adibook/pages/pupil/account_section.dart';
import 'package:adibook/pages/pupil/me_section.dart';
import 'package:adibook/pages/pupil/resources_section.dart';
import 'package:adibook/utils/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class PageManager {
  List<WidgetConfiguration> get instructorWidgetsConfiguration {
    return this
        ._widgetList
        .where((w) => w.availableFor == UserType.Instructor)
        .toList();
  }

  List<WidgetConfiguration> get pupilWidgetsConfiguration {
    return this
        ._widgetList
        .where((w) => w.availableFor == UserType.Pupil)
        .toList();
  }

  List<WidgetConfiguration> getWidgetsConfigurationByUserType(
      UserType userType) {
    if (userType == UserType.Instructor)
      return this.instructorWidgetsConfiguration;
    if (userType == UserType.Pupil) return this.pupilWidgetsConfiguration;
    return [];
  }

  List<Widget> getWidgetsByUserType(UserType userType) {
    if (userType == UserType.Instructor)
      return this
          .instructorWidgetsConfiguration
          .map((f) => f.sectionWidget)
          .toList();
    if (userType == UserType.Pupil)
      return this
          .instructorWidgetsConfiguration
          .map((f) => f.sectionWidget)
          .toList();
    return [];
  }

  List<WidgetConfiguration> _widgetList = [
    WidgetConfiguration(
      index: 0,
      appBarTitle: 'Pupil',
      bottomNavTitle: 'Pupil',
      availableFor: UserType.Instructor,
      sectionWidget: PupilListSection(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
    ),
    WidgetConfiguration(
      index: 1,
      appBarTitle: 'Add Pupil',
      bottomNavTitle: 'Add Pupil',
      availableFor: UserType.Instructor,
      sectionWidget: AddPupilSection(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
    ),
    WidgetConfiguration(
      index: 2,
      appBarTitle: 'Diary',
      bottomNavTitle: 'Diary',
      availableFor: UserType.Instructor,
      sectionWidget: EventListSection(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
    ),
    WidgetConfiguration(
      index: 3,
      appBarTitle: 'Your Messages',
      bottomNavTitle: 'Messages',
      availableFor: UserType.Instructor,
      sectionWidget: MessageListSection(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
    ),
    WidgetConfiguration(
      index: 4,
      appBarTitle: 'More',
      bottomNavTitle: 'More',
      availableFor: UserType.Instructor,
      sectionWidget: MoreList(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
    ),
    WidgetConfiguration(
      index: 0,
      appBarTitle: 'Me',
      bottomNavTitle: 'Me',
      availableFor: UserType.Pupil,
      sectionWidget: MeSection(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
    ),
    WidgetConfiguration(
      index: 1,
      appBarTitle: 'Ability',
      bottomNavTitle: 'Ability',
      availableFor: UserType.Pupil,
      sectionWidget: AbilitySection(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
    ),
    WidgetConfiguration(
      index: 2,
      appBarTitle: 'Resources',
      bottomNavTitle: 'Resources',
      availableFor: UserType.Pupil,
      sectionWidget: ResourcesSection(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
    ),
    WidgetConfiguration(
      index: 3,
      appBarTitle: 'Account',
      bottomNavTitle: 'Account',
      availableFor: UserType.Pupil,
      sectionWidget: AccountSection(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
    ),
  ];
}

class WidgetConfiguration {
  WidgetConfiguration(
      {int index,
      String appBarTitle,
      String bottomNavTitle,
      UserType availableFor,
      Widget sectionWidget,
      Icon bottomNavIcon})
      : this.index = index,
        this.appBartitle = appBarTitle,
        this.bottomNavTitle = bottomNavTitle,
        this.availableFor = availableFor,
        this.sectionWidget = sectionWidget,
        this.bottomNavIcon = bottomNavIcon;
  int index;
  String appBartitle;
  String bottomNavTitle;
  UserType availableFor;
  Widget sectionWidget;
  Icon bottomNavIcon;
}
