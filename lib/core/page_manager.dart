import 'package:adibook/core/constants.dart';
import 'package:adibook/pages/instructor/add_pupil_section.dart';
import 'package:adibook/pages/instructor/event_list_section.dart';
import 'package:adibook/pages/instructor/instructor_profile.dart';
import 'package:adibook/pages/instructor/pupil_activities/add_lesson_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/lesson_list_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/progress_planner_section.dart';
import 'package:adibook/pages/instructor/pupil_list_section.dart';
import 'package:adibook/pages/pupil/ability_section.dart';
import 'package:adibook/pages/pupil/account_section.dart';
import 'package:adibook/pages/pupil/resources_section.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WidgetConfiguration {
  WidgetConfiguration(
      {this.index,
      this.appBarTitle,
      this.bottomNavTitle,
      this.availableFor,
      this.sectionWidget,
      this.bottomNavIcon,
      this.sectionType});
  int index;
  String appBarTitle;
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
        .where(
            (w) => w.availableFor == userType && w.sectionType == sectionType)
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
      appBarTitle: 'Profile',
      bottomNavTitle: 'Profile',
      availableFor: UserType.Instructor,
      sectionWidget: InstructorProfile(),
      bottomNavIcon: Icon(FontAwesomeIcons.addressCard, color: Colors.white),
      sectionType: SectionType.InstructorActivity,
    ),
    WidgetConfiguration(
      index: 0,
      appBarTitle: 'Profile',
      bottomNavTitle: 'Profile',
      availableFor: UserType.Pupil,
      sectionWidget: AddPupilSection(),
      bottomNavIcon: Icon(FontAwesomeIcons.addressCard, color: Colors.white),
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
      appBarTitle: 'Lesson List',
      bottomNavTitle: 'Lessons',
      availableFor: UserType.Instructor,
      sectionWidget: LessonListSection(),
      bottomNavIcon: Icon(Icons.list, color: Colors.white),
      sectionType: SectionType.InstructorActivityForPupil,
    ),
    WidgetConfiguration(
      index: 1,
      appBarTitle: 'Add Lesson',
      bottomNavTitle: 'Add Lesson',
      availableFor: UserType.Instructor,
      sectionWidget: AddLessonSection(),
      bottomNavIcon: Icon(FontAwesomeIcons.plus, color: Colors.white),
      sectionType: SectionType.InstructorActivityForPupil,
    ),
    WidgetConfiguration(
      index: 2,
      appBarTitle: 'Progress Planner',
      bottomNavTitle: 'Progress Planner',
      availableFor: UserType.Instructor,
      sectionWidget: ProgressPlannerSection(),
      bottomNavIcon: Icon(FontAwesomeIcons.addressCard, color: Colors.white),
      sectionType: SectionType.InstructorActivityForPupil,
    ),
    
  ];

  SectionType defaultSectionType(UserType userType) {
    return _getUsersSectionsConfig()
        .firstWhere((f) => f.userType == userType && f.isDefault)
        .sectionType;
  }

  List<_UsersSectionType> _getUsersSectionsConfig() {
    return [
      _UsersSectionType(
        userType: UserType.Admin,
        sectionType: SectionType.AdminActivity,
        isDefault: true,
      ),
      _UsersSectionType(
        userType: UserType.Instructor,
        sectionType: SectionType.InstructorActivity,
        isDefault: true,
      ),
      _UsersSectionType(
        userType: UserType.Instructor,
        sectionType: SectionType.InstructorActivityForPupil,
        isDefault: false,
      ),
      _UsersSectionType(
        userType: UserType.Pupil,
        sectionType: SectionType.PupilActivity,
        isDefault: true,
      )
    ];
  }
}

class _UsersSectionType {
  _UsersSectionType({
    this.userType,
    this.sectionType,
    this.isDefault,
  });
  UserType userType;
  SectionType sectionType;
  bool isDefault;
}
