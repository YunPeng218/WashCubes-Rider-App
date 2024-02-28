import 'order.dart';

enum JobType {
  lockerToLaundrySite,
  laundrySiteToLocker,
}

class Job {
  String jobNumber;
  String rider;
  JobType jobType;
  String lockerSite;
  List<Order> orders;
  bool isJobActive;
  bool pickedUpStatus;
  bool dropOffStatus;

  Job({
    required this.jobNumber,
    required this.rider,
    required this.jobType,
    required this.lockerSite,
    required this.orders,
    required this.isJobActive,
    required this.pickedUpStatus,
    required this.dropOffStatus,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      jobNumber: json['jobNumber'] ?? '',
      rider: json['rider'] ?? '',
      jobType: _parseJobType(json['jobType']),
      lockerSite: json['lockerSite'] ?? '',
      orders: (json['orders'] as List<dynamic>?)
              ?.map((orderJson) => Order.fromJson(orderJson))
              .toList() ??
          [],
      isJobActive: json['isJobActive'],
      pickedUpStatus: json['pickedUpStatus'],
      dropOffStatus: json['dropOffStatus'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'jobNumber': jobNumber,
  //     'rider': rider,
  //     'jobType': _serializeJobType(jobType),
  //     'lockerSite': lockerSite,
  //     'orders': orders.map((order) => Order.toJson(order)).toList(),
  //   };
  // }

  static JobType _parseJobType(String value) {
    return value == 'Locker To Laundry Site'
        ? JobType.lockerToLaundrySite
        : JobType.laundrySiteToLocker;
  }

  // static String _serializeJobType(JobType jobType) {
  //   return jobType == JobType.lockerToLaundrySite
  //       ? 'Locker To Laundry Site'
  //       : 'Laundry Site to Locker';
  // }

  String get jobTypeString {
    switch (jobType) {
      case JobType.lockerToLaundrySite:
        return 'Locker to Laundry Site';
      case JobType.laundrySiteToLocker:
        return 'Laundry Site to Locker';
    }
  }
}
