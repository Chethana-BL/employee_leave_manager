import 'package:flutter/material.dart';

import '../absence_status.dart';
import '../absence_type.dart';
import '../member.dart';

/// This class is used to manage the filter state for the absence list
class AbsenceFilterModel {
  AbsenceFilterModel({
    this.type,
    this.status,
    this.employee,
    this.dateRange,
  });
  AbsenceType? type;
  AbsenceStatus? status;
  Member? employee;
  DateTimeRange? dateRange;

  int get activeCount =>
      [type, status, employee, dateRange].where((e) => e != null).length;

  void clear() {
    type = null;
    status = null;
    employee = null;
    dateRange = null;
  }

  AbsenceFilterModel copy() => AbsenceFilterModel(
        type: type,
        status: status,
        employee: employee,
        dateRange: dateRange,
      );
}
