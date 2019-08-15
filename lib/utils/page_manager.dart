import 'package:adibook/pages/instructor/add_pupil_section.dart';
import 'package:adibook/pages/instructor/event_list_section.dart';
import 'package:adibook/pages/instructor/message_list_section.dart';
import 'package:adibook/pages/instructor/more_list_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/add_lesson_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/progress_planner.dart';
import 'package:adibook/pages/instructor/pupil_list_section.dart';
import 'package:adibook/pages/pupil/ability_section.dart';
import 'package:adibook/pages/pupil/account_section.dart';
import 'package:adibook/pages/pupil/me_section.dart';
import 'package:adibook/pages/pupil/resources_section.dart';
import 'package:adibook/utils/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WidgetConfiguration {
  WidgetConfiguration(
      {int index,
      String appBarTitle,
      String bottomNavTitle,
      UserType availableFor,
      Widget sectionWidget,
      Icon bottomNavIcon,
      SectionType sectionType})
      : this.index = index,
        this.appBartitle = appBarTitle,
        this.bottomNavTitle = bottomNavTitle,
        this.availableFor = availableFor,
        this.sectionWidget = sectionWidget,
        this.bottomNavIcon = bottomNavIcon,
        this.sectionType = sectionType;
  int index;
  String appBartitle;
  String bottomNavTitle;
  UserType availableFor;
  Widget sectionWidget;
  Icon bottomNavIcon;
  SectionType sectionType;
}

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

  List<Widget> getWidgets(UserType userType, SectionType sectionType) {
    return this
        .getWidgetConfigurations(userType, sectionType)
        .map((f) => f.sectionWidget)
        .toList();
  }

  List<WidgetConfiguration> getWidgetConfigurations(
      UserType userType, SectionType sectionType) {
    return this
        ._widgetList
        .where((w) => w.availableFor == userType && w.sectionType == sectionType)
        .toList();
  }

  List<WidgetConfiguration> _widgetList = [
    WidgetConfiguration(
      index: 0,
      appBarTitle: 'Pupil',
      bottomNavTitle: 'Pupil',
      availableFor: UserType.Instructor,
      sectionWidget: PupilListSection(),
      bottomNavIcon: Icon(EvaIcons.person, color: Colors.white),
      sectionType: SectionType.InstructorActivity,
    ),
    WidgetConfiguration(
      index: 1,
      appBarTitle: 'Add Pupil',
      bottomNavTitle: 'Add Pupil',
      availableFor: UserType.Instructor,
      sectionWidget: AddPupilSection(),
      bottomNavIcon: Icon(EvaIcons.plus, color: Colors.white),
      sectionType: SectionType.InstructorActivity,
    ),
    WidgetConfiguration(
      index: 2,
      appBarTitle: 'Diary',
      bottomNavTitle: 'Diary',
      availableFor: UserType.Instructor,
      sectionWidget: EventListSection(),
      bottomNavIcon: Icon(EvaIcons.book, color: Colors.white),
      sectionType: SectionType.InstructorActivity,
    ),
    WidgetConfiguration(
      index: 3,
      appBarTitle: 'Your Messages',
      bottomNavTitle: 'Messages',
      availableFor: UserType.Instructor,
      sectionWidget: MessageListSection(),
      bottomNavIcon: Icon(EvaIcons.bell, color: Colors.white),
      sectionType: SectionType.InstructorActivity,
    ),
    WidgetConfiguration(
      index: 4,
      appBarTitle: 'More',
      bottomNavTitle: 'More',
      availableFor: UserType.Instructor,
      sectionWidget: MoreList(),
      bottomNavIcon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
      sectionType: SectionType.InstructorActivity,
    ),
    WidgetConfiguration(
      index: 0,
      appBarTitle: 'Me',
      bottomNavTitle: 'Me',
      availableFor: UserType.Pupil,
      sectionWidget: MeSection(),
      bottomNavIcon: Icon(FontAwesomeIcons.user, color: Colors.white),
      sectionType: SectionType.PupilActivity,
    ),
    WidgetConfiguration(
      index: 1,
      appBarTitle: 'Ability',
      bottomNavTitle: 'Ability',
      availableFor: UserType.Pupil,
      sectionWidget: AbilitySection(),
      bottomNavIcon: Icon(Icons.settings_applications, color: Colors.white),
      sectionType: SectionType.PupilActivity,
    ),
    WidgetConfiguration(
      index: 2,
      appBarTitle: 'Resources',
      bottomNavTitle: 'Resources',
      availableFor: UserType.Pupil,
      sectionWidget: ResourcesSection(),
      bottomNavIcon: Icon(FontAwesomeIcons.graduationCap, color: Colors.white),
      sectionType: SectionType.PupilActivity,
    ),
    WidgetConfiguration(
      index: 3,
      appBarTitle: 'Account',
      bottomNavTitle: 'Account',
      availableFor: UserType.Pupil,
      sectionWidget: AccountSection(),
      bottomNavIcon: Icon(Icons.account_circle, color: Colors.white),
      sectionType: SectionType.PupilActivity,
    ),
    WidgetConfiguration(
      index: 0,
      appBarTitle: 'Add Lesson',
      bottomNavTitle: 'Add Lesson',
      availableFor: UserType.Instructor,
      sectionWidget: AddLesson(),
      bottomNavIcon: Icon(Icons.book, color: Colors.white),
      sectionType: SectionType.InstructorActivityForPupil,
    ),
    WidgetConfiguration(
      index: 0,
      appBarTitle: 'Progress Planner',
      bottomNavTitle: 'Progress Planner',
      availableFor: UserType.Instructor,
      sectionWidget: ProgressPlanner(),
      bottomNavIcon: Icon(Icons.book, color: Colors.white),
      sectionType: SectionType.InstructorActivityForPupil,
    ),
  ];
}
