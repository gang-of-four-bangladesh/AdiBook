import 'package:adibook/core/app_data.dart';
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
  Future<List<ProgressPlanViewModel>> getProgressDetails() async {
    List<ProgressPlanViewModel> _data = [];
    var progressSnap = await ProgressPlan(
            pupilId: appData.pupil.id, instructorId: appData.instructor.id)
        .get();
    this._logger.info('Progress snap $progressSnap');
    for (var progressPlanSubject in progressPlanSubjects) {
      var progressData = ProgressPlanViewModel(
        subjectDisplayName: progressPlanSubject.values.first,
        subjectName: progressPlanSubject.keys.first,
      );
      _data.add(progressData);
      if (!progressSnap.exists) continue;

      var subjectDeatils = progressSnap[progressPlanSubject.keys.first];
      this._logger.info('Subject details from firestore $subjectDeatils');
      if (subjectDeatils == null) continue;

      this._logger.info(
          'Progress status for ${progressData.subjectDisplayName} is ${progressSnap[progressPlanSubject.keys.first][ProgressPlanSubject.StatusKey]}');
      progressData.status = ProgressSubjectStatus.values[
          progressSnap[progressPlanSubject.keys.first]
              [ProgressPlanSubject.StatusKey]];
    }
    return _data;
  }

  Future<double> getProgressPercentage() async {
    var progressDetails = await this.getProgressDetails();
    int ratingSum = 0;
    progressDetails.forEach((p) => ratingSum += p.status.index);
    var percent = ratingSum / (progressPlanSubjects.length * 5);
    this._logger.info('Total Subjects are ${progressPlanSubjects.length}, and rating summation is $ratingSum.');
    return percent;
  }

  static const progressPlanSubjects = [
    {
      "nmo": "Normal move off",
    },
    {
      "amo": "Angled move off",
    },
    {
      "hst": "Hill start",
    },
    {
      "dmo": "Decline move off",
    },
    {
      "mobr": "Move off busy road",
    },
    {
      "spts": "Safe places to stop",
    },
    {
      "pp": "Parallel park",
    },
    {
      "bprk": "Bay park",
    },
    {
      "fbprk": "Forward bay park",
    },
    {
      "titr": "Turn in the road",
    },
    {
      "rttl": "Reverse to the left",
    },
    {
      "rttr": "Reverse to the right",
    },
    {
      "puosr": "Pull up, opposite side of the road",
    },
    {
      "mac": "Meeting & clearance",
    },
    {
      "ant": "Anticipation",
    },
    {
      "atsl": "Attention to speed limits",
    },
    {
      "guoh": "General use of handbrake",
    },
    {
      "estp": "Emergency stop",
    },
    {
      "es3": "Emergency stop 30mph+",
    },
    {
      "crd": "Country roads",
    },
    {
      "rabt": "Roundabouts",
    },
    {
      "mrbt": "Mini roundabouts",
    },
    {
      "cjnc": "Complex junctions",
    },
    {
      "mtrw": "Motorway",
    },
    {
      "dcrg": "Dual carriageways",
    },
    {
      "jdc": "Joining/leaving dual carriageways",
    },
    {
      "idpd": "Independent driving",
    },
    {
      "grp": "General road position",
    },
    {
      "guog": "General use of gears",
    },
    {
      "poh": "Progress/hesitancy",
    },
    {
      "maj": "MSPSL all junctions",
    },
    {
      "crst": "Crossing traffic",
    },
    {
      "pdcrs": "Pedestrian crossings",
    },
    {
      "idbsn": "Independent driving by sat nav",
    },
    {
      "idbrs": "Independant driving by road signs",
    },
    {
      "kota": "Knowledge of test area",
    },
    {
      "mkt": "Mock test",
    },
    {
      "cmtdrv": "Commentary drive",
    },
    {
      "uoac": "Use of ancillary controls",
    },
    {
      "cdam": "Cockpit drills and controls",
    },
    {
      "stpn": "Stopping normally",
    },
    {
      "str": "Steering",
    },
    {
      "cltchc": "Clutch control",
    },
    {
      "tlmtm": "Turning left, major to minor",
    },
    {
      "trmtm": "Turning right, major to minor",
    },
    {
      "etjo": "Emerging t-junctions open",
    },
    {
      "emrgb": "Emerging blind",
    },
    {
      "tjnc": "T-junctions",
    },
    {
      "crsr": "Cross roads",
    },
    {
      "ctfr": "Crossing traffic on fast roads",
    },
    {
      "uosp": "Use of speed",
    },
    {
      "tlgt": "Traffic lights",
    },
    {
      "emu": "Effective mirror use",
    },
    {
      "uosg": "Use of signals",
    },
    {
      "dblr": "Double roundabouts",
    },
    {
      "puotr": "Pull up on the right",
    },
    {
      "smq": "Show me questions (on the move)",
    },
    {
      "tmq": "Tell me questions",
    },
    {
      "cdr": "Cockpit Drill",
    },
    {
      "mos": "Moving Off and Stopping",
    },
    {
      "aju": "Approaching Junctions",
    },
    {
      "emrgng": "Emerging",
    },
    {
      "mtrfc": "Meeting Traffic",
    },
    {
      "emrgs": "Emergency Stop",
    },
    {
      "pdscrs": "Pedestrian Crossing",
    },
    {
      "hawrns": "Hazard Awareness",
    },
    {
      "prgsmr": "Progress - Main Roads",
    },
    {
      "rndabts": "Roundabouts",
    },
    {
      "dlcrgaws": "Dual Carriageways",
    },
    {
      "tntr": "Turn in the Road",
    },
    {
      "ritb": "Reverse into a Bay",
    },
    {
      "pprk": "Parallel Parking",
    },
    {
      "rracnr": "Reverse Around a Corner",
    },
    {
      "smtm": "Show Me, Tell Me",
    },
  ];
}
