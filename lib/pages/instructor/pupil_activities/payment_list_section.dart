import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PaymentListSection extends StatefulWidget {
  @override
  PaymentListSectionState createState() => PaymentListSectionState();
}

class PaymentListSectionState extends State<PaymentListSection> {
  bool flagWarranty = false;
  Stream<QuerySnapshot> _querySnapshot;
  FrequentWidgets frequentWidgets = FrequentWidgets();
  Logger _logger = Logger('page->payment_list');
  @override
  void initState() {
    super.initState();
    _loadPaymentsData();
  }

  void _loadPaymentsData() async {
    var pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    if (isNullOrEmpty(pupilId)) return;
    if (!mounted) return;
    setState(() {
      _querySnapshot = PupilManager()
          .getPayments(
              instructorId: appData.instructor.id, pupilId: pupilId)
          .asStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Loading pupil payments listing page.');
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var format = DateFormat("EEEE dd MMMM");
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.data == null) return FrequentWidgets().getProgressBar();
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return FrequentWidgets().getProgressBar();
          default:
            return ListView(
              children: snapshot.data.documents.map(
                (DocumentSnapshot document) {
                  return Slidable(
                      actionPane: SlidableScrollActionPane(),
                      actionExtentRatio: 0.12,
                      child: ListTile(
                        onTap: () {
                          print("clicked");
                        },
                        title: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              //  Payment Date,
                              Container(
                                padding: EdgeInsets.only(left: 2.0, right: 2.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /*2*/
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    ("Amount: " +
                                                        document[Payment
                                                                .AmountKey]
                                                            .toString() +
                                                        "\$"),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    ("Payment Date: " +
                                                        format
                                                            .format(TypeConversion
                                                                .timeStampToDateTime(
                                                                    document[Payment
                                                                        .PaymentDateKey]))
                                                            .toString()),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    "Payment Type: " +
                                                        enumValueToString(PaymentType
                                                            .values[int.parse(
                                                                document[Payment
                                                                        .PaymentTypeKey]
                                                                    .toString())]
                                                            .toString()),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ).toList(),
            );
        }
      },
    );
  }

  String enumValueToString(String enumvalue) {
    return enumvalue
        .toString()
        .substring(enumvalue.toString().indexOf('.') + 1);
  }
}
