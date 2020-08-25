import 'package:adibook/core/constants.dart';
import 'package:adibook/models/progress_plan.dart';
import 'package:logging/logging.dart';

class ProgressPlanViewModel {
  ProgressPlanViewModel({
    this.subjectDisplayName,
    this.subjectName,
    this.status = ProgressSubjectStatus.None,
  });
  String subjectName;
  String subjectDisplayName;
  ProgressSubjectStatus status;
}

class ProgressPlanManager {
  Logger _logger = Logger('progress_plan_manager');
  Future<List<ProgressPlanViewModel>> getProgressDetails(
      {String pupilId, String instructorId}) async {
    List<ProgressPlanViewModel> _data = [];
    var progressSnap =
        await ProgressPlan(pupilId: pupilId, instructorId: instructorId).get();
    this._logger.info('Progress snap $progressSnap');
    for (var progressPlanSubject in progressPlanSubjects) {
      var progressData = ProgressPlanViewModel(
        subjectDisplayName: progressPlanSubject.values.first,
        subjectName: progressPlanSubject.keys.first,
      );
      _data.add(progressData);
      if (!progressSnap.exists) continue;

      var subjectDeatils = progressSnap.data()[progressPlanSubject.keys.first];
      this._logger.info('Subject details from firestore $subjectDeatils');
      if (subjectDeatils == null) continue;

      this._logger.info(
          'Progress status for ${progressData.subjectDisplayName} is ${progressSnap.data()[progressPlanSubject.keys.first][ProgressPlanSubject.StatusKey]}');
      progressData.status = ProgressSubjectStatus.values[
          progressSnap.data()[progressPlanSubject.keys.first]
              [ProgressPlanSubject.StatusKey]];
    }
    return _data;
  }

  Future<double> getProgressPercentage(List<ProgressPlanViewModel> progressDetails) async {   
    int ratingSum = 0;
    progressDetails.forEach((p) => ratingSum += p.status.index);
    var percent = ratingSum / (progressPlanSubjects.length * 4);
    this._logger.info(
        'Total Subjects are ${progressPlanSubjects.length}, and rating summation is $ratingSum.');
    return percent;
  }

  static const progressPlanSubjects = [
    {"ccsc": "COCKPIT (CHECKS / SAFETY CHECKS"},
    {"ci": "CONTROLS & INSTRUMENTS"},
    {"mas": "MOVING AWAY & STOPPING"},
    {"spts": "Safe places to stop"},
    {"spgrp": "SAFE POSITIONING/ General Road Position "},
    {"emu": "Effective mirror use"},
    {"s": "SIGNALS"},
    {"hs": "Hill start"},
    {"tl": "Traffic lights"},
    {"ap": "ANTICIPATION & PLANNING"},
    {"mc": "Meeting & Clearance"},
    {"p": "Progress/hesitancy"},
    {"uos": "USE OF SPEED"},
    {"ot": "OTHER TRAFFIC"},
    {"m": "MSPSL"},
    {"tlmtm": "Turning left, major to minor"},
    {"trmtm": "Turning right, major to minor"},
    {"eto": "Emerging t-junctions open"},
    {"etb": "Emerging T-junctions blind"},
    {"cr": "Cross roads"},
    {"r": "ROUNDABOUTS"},
    {"mr": "MINI ROUNDABOUTS"},
    {"pc": "PEDESTRIAN CROSSINGS"},
    {"dcj": "DUAL CARRIAGEWAYS (Joining/leaving)"},
    {"wr": "WET ROADS"},
    {"dr": "DRY ROADS"},
    {"d": "DARKNESS"},
    {"d0": "DAYLIGHT"},
    {"c": "COUNTRY"},
    {"tac": "TOWN AND CITY"},
    {"m0": "Motorway"},
    {"idbs": "Independant driving by satnav"},
    {"idbr": "Independant driving by Roadsign"},
    {"cses": "Controlled Stop (Emergency Stop)"},
    {"puotr": "Pulling up on the right"},
    {"pp": "Parallel Parking "},
    {"fbp": "Forward Bay Parking "},
    {"rbp": "Reverse Bay Parking "},
    {"titrtpt": "Turn in the Road (Three Point Turn)"},
    {"smqotm": "Show me questions (On the move)"},
    {"tmq": "Tell me questions"},
    {"er1": "Exam Route 1"},
    {"er2": "Exam Route 2"},
    {"er3": "Exam Route 3"},
    {"er4": "Exam Route 4"},
    {"er5": "Exam Route 5"},
    {"er6": "Exam Route 6"},
    {"er7": "Exam Route 7"},
    {"er8": "Exam Route 8"},
    {"er9": "Exam Route 9"},
    {"er10": "Exam Route 10"},
    {"mt1": "Mock test 1"},
    {"mt2": "Mock test 2"},
    {"mt3": "Mock test 3"}
  ];
}
