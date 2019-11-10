import 'package:adibook/core/constants.dart';
import 'package:adibook/pages/instructor/add_pupil_section.dart';
import 'package:adibook/pages/instructor/event_list_section.dart';
import 'package:adibook/pages/instructor/instructor_profile.dart';
import 'package:adibook/pages/instructor/pupil_activities/add_lesson_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/add_payment_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/lesson_list_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/payment_list_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/progress_planner_section.dart';
import 'package:adibook/pages/instructor/pupil_list_section.dart';
import 'package:adibook/pages/pupil/status_section.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WidgetConfiguration {
  WidgetConfiguration(
      {this.index,
      this.appBarText,
      this.drawerLinkText,
      this.availableFor,
      this.sectionWidget,
      this.bottomNavIcon,
      this.sectionType,
      this.drawerOnly});
  int index;
  String appBarText;
  String drawerLinkText;
  UserType availableFor;
  Widget sectionWidget;
  Icon bottomNavIcon;
  SectionType sectionType;
  bool drawerOnly;
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

  List<WidgetConfiguration> getTabBarWidgetConfigurations(
      UserType userType, SectionType sectionType) {
    return getWidgetConfigurations(userType, sectionType)
        .where((f) => !f.drawerOnly);
  }

  List<WidgetConfiguration> _widgetList = [
    WidgetConfiguration(
      index: 0,
      appBarText: 'Pupils',
      drawerLinkText: 'Pupils',
      availableFor: UserType.Instructor,
      sectionWidget: PupilListSection(),
      bottomNavIcon: Icon(EvaIcons.person, color: Colors.white),
      sectionType: SectionType.InstructorActivity,
    ),
    WidgetConfiguration(
        index: 1,
        appBarText: 'New Pupil',
        drawerLinkText: 'New Pupil',
        availableFor: UserType.Instructor,
        sectionWidget: AddPupilSection(),
        bottomNavIcon: Icon(EvaIcons.plus, color: Colors.white),
        sectionType: SectionType.InstructorActivity,
        drawerOnly: true),
    WidgetConfiguration(
      index: 2,
      appBarText: 'Diary',
      drawerLinkText: 'Diary',
      availableFor: UserType.Instructor,
      sectionWidget: EventListSection(),
      bottomNavIcon: Icon(EvaIcons.book, color: Colors.white),
      sectionType: SectionType.InstructorActivity,
    ),

    WidgetConfiguration(
      index: 3,
      appBarText: 'Profile',
      drawerLinkText: 'Profile',
      availableFor: UserType.Instructor,
      sectionWidget: InstructorProfile(),
      bottomNavIcon: Icon(FontAwesomeIcons.addressCard, color: Colors.white),
      sectionType: SectionType.InstructorActivity,
    ),
    WidgetConfiguration(
      index: 0,
      appBarText: 'Status',
      drawerLinkText: 'Status',
      availableFor: UserType.Pupil,
      sectionWidget: StatusSection(),
      bottomNavIcon: Icon(Icons.people, color: Colors.white),
      sectionType: SectionType.PupilActivity,
    ),
    WidgetConfiguration(
      index: 1,
      appBarText: 'Profile',
      drawerLinkText: 'Profile',
      availableFor: UserType.Pupil,
      sectionWidget: AddPupilSection(),
      bottomNavIcon: Icon(FontAwesomeIcons.infoCircle, color: Colors.white),
      sectionType: SectionType.PupilActivity,
    ),
    WidgetConfiguration(
      index: 2,
      appBarText: 'Lessons',
      drawerLinkText: 'Lessons',
      availableFor: UserType.Pupil,
      sectionWidget: LessonListSection(),
      bottomNavIcon: Icon(FontAwesomeIcons.graduationCap, color: Colors.white),
      sectionType: SectionType.PupilActivity,
    ),
    WidgetConfiguration(
      index: 0,
      appBarText: 'Lesson List',
      drawerLinkText: 'Lessons',
      availableFor: UserType.Instructor,
      sectionWidget: LessonListSection(),
      bottomNavIcon: Icon(Icons.list, color: Colors.white),
      sectionType: SectionType.InstructorActivityForPupil,
    ),
    WidgetConfiguration(
      index: 1,
      appBarText: 'Payment List',
      drawerLinkText: 'Payments',
      availableFor: UserType.Instructor,
      sectionWidget: PaymentListSection(),
      bottomNavIcon: Icon(Icons.list, color: Colors.white),
      sectionType: SectionType.InstructorActivityForPupil,
    ),
    WidgetConfiguration(
        index: 2,
        appBarText: 'Add Lesson',
        drawerLinkText: 'Add Lesson',
        availableFor: UserType.Instructor,
        sectionWidget: AddLessonSection(),
        bottomNavIcon: Icon(FontAwesomeIcons.plus, color: Colors.white),
        sectionType: SectionType.InstructorActivityForPupil,
        drawerOnly: true),
    // WidgetConfiguration(
    //   index: 3,
    //   appBarTitle: 'Add Payment',
    //   bottomNavTitle: 'Add Payment',
    //   availableFor: UserType.Instructor,
    //   sectionWidget: AddPaymentSection(),
    //   bottomNavIcon: Icon(FontAwesomeIcons.plus, color: Colors.white),
    //   sectionType: SectionType.InstructorActivityForPupil,
    // ),
    WidgetConfiguration(
      index: 3,
      appBarText: 'Progress',
      drawerLinkText: 'Progress',
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
