
import 'package:xenon_cp/model/numbers_elements_view.dart/number_view.dart';

class ServerStat {
  ServerStat({
    this.cpuUsage,
    this.ramUsage,
    this.netUsage,
    this.diskUsage,
    this.eventStat,
  });

  ServerStat.zero({
    this.cpuUsage,
    this.ramUsage,
    this.netUsage,
    this.diskUsage,
    this.eventStat,
  }) {
    cpuUsage = CpuUsageStat.zero();
    ramUsage = RamUsageStat.zero();
    netUsage = NetUsageStat.zero();
    diskUsage = DiskUsageStat.zero();
    eventStat = EventsStat.zero();
  }

  late CpuUsageStat? cpuUsage;
  late RamUsageStat? ramUsage;
  late NetUsageStat? netUsage;
  late DiskUsageStat? diskUsage;
  late EventsStat? eventStat;

  Map<String, dynamic> toMap() => {
        'cu': cpuUsage?.toMap(),
        'ru': ramUsage?.toMap(),
        'du': diskUsage?.toMap(),
        'nu': netUsage?.toMap(),
        'es': eventStat?.toMap(),
      };

  static ServerStat fromMap(Map<String, dynamic> insMap) {
    return ServerStat(
      cpuUsage: () {
        try {
          return CpuUsageStat.fromMap(insMap['cu']);
        } catch (e) {
          print(e);
        }
      }.call(),
      ramUsage: () {
        try {
          return RamUsageStat.fromMap(insMap['ru']);
        } catch (e) {
          print(e);
        }
      }.call(),
      netUsage: () {
        try {
          return NetUsageStat.fromMap(insMap['nu']);
        } catch (e) {
          print(e);
        }
      }.call(),
      diskUsage: () {
        try {
          return DiskUsageStat.fromMap(insMap['du']);
        } catch (e) {
          print(e);
        }
      }.call(),
      eventStat: () {
        try {
          return EventsStat.fromMap(insMap['es']);
        } catch (e) {
          print(e);
        }
      }.call(),
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class EventsStat {
  EventsStat();
  NumbersView? spiderErrors;
  NumbersView? spiderSuccesses;
  NumbersView? spiderExceptions;
  NumbersView? xenonErrors;
  NumbersView? xenonSuccesses;
  NumbersView? xenonExceptions;
  NumbersView? totalErrors;
  NumbersView? totalSuccesses;
  NumbersView? totalExceptions;

  static zero() => EventsStat.fromMap({
        'totalErrors': '0',
        'totalSuccesses': '0',
        'totalExceptions': '0',
        'spiderErrors': '0',
        'spiderSuccesses': '0',
        'spiderExceptions': '0',
        'xenonErrors': '0',
        'xenonSuccesses': '0',
        'xenonExceptions': '0',
      });

  toMap() => {
        'totalErrors': totalErrors,
        'totalSuccesses': totalSuccesses,
        'totalExceptions': totalExceptions,
        'spiderErrors': spiderErrors,
        'spiderSuccesses': spiderSuccesses,
        'spiderExceptions': spiderExceptions,
        'xenonErrors': xenonErrors,
        'xenonSuccesses': xenonSuccesses,
        'xenonExceptions': xenonExceptions,
      };

  EventsStat.fromMap(Map<String, dynamic> statMap) {
    // EventsStat _eventsStat = EventsStat();
    spiderErrors = _toNv(statMap['spiderErrors']);
    spiderSuccesses = _toNv(statMap['spiderSuccesses']);
    spiderExceptions = _toNv(statMap['spiderExceptions']);
    xenonErrors = _toNv(statMap['xenonErrors']);
    xenonSuccesses = _toNv(statMap['xenonSuccesses']);
    xenonExceptions = _toNv(statMap['xenonExceptions']);
    totalErrors = _nvNullChk(spiderErrors) + _nvNullChk(xenonErrors);
    totalSuccesses = _nvNullChk(spiderSuccesses) + _nvNullChk(xenonSuccesses);
    totalExceptions =
        _nvNullChk(spiderExceptions) + _nvNullChk(xenonExceptions);
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

/// TODO: more data can be maintained
/// - Name and module
/// - threads Threads Number
/// - process [Process Number]
/// - up time [9:01:01]
/// - L caches [128KB, 512KB, 3.0MB]
/// - Virtualization [Enabled, Disabled]
class CpuUsageStat {
  NumbersView usage = NumbersView('0');
  // late String? speed = '0 GHz';
  NumbersView? frequency = NumbersView('0');
  NumbersView? coresNumber;
  List<String>? coresUsage;

  static zero() => CpuUsageStat.fromMap({
        'coresNumber': '0',
        'coresUsage': ['0'],
        'usage': '0',
        'frequency': '0',
      });

  Map<String, dynamic> toMap() => {
        'coresNumber': coresNumber,
        'coresUsage': coresUsage,
        'usage': usage,
        'frequency': frequency,
      };

  static CpuUsageStat fromMap(Map<String, dynamic> statMap) {
    // print((statMap['usage'] as String).getIntBetween(16, 39));
    // print((statMap['usage'] as String).getIntBetween(16, 39)?.length);
    // print((statMap['usage'] as String).substring(39).length);
    return CpuUsageStat()
      ..coresNumber = _toNv(statMap['coresNumber'])
      ..coresUsage = statMap['coresUsage']
      // ..usage = (statMap['usage'] as String).getIntBetween(16, 39) ?? '0'
      ..usage = _toNv(statMap['usage'])
      ..frequency = _toNv(statMap['frequency']);
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

extension GetIntBetween on String {
  String? getIntBetween(int start, [int? end]) {
    String result = '';
    for (String expectNum in substring(start, end).split('')) {
      var parseResult = int.tryParse(expectNum);
      if (parseResult != null) {
        result = result + expectNum;
      }
    }
    return int.tryParse(result)?.toString();
  }
}

/// TODO: more data can be maintained
/// - gen of DDR
/// - Speed in MHz
/// - FormFactor
/// - In use compressed
/// - commited
/// - cahed
/// - paged & non paged pool
class RamUsageStat {
  RamUsageStat({
    this.capacity,
    this.freeBytes,
    this.freeSpace,
    this.usedBytes,
    this.usedSpace,
  });

  /// The Total Ram capacity
  NumbersView? capacity;
  NumbersView? freeBytes;
  NumbersView? usedBytes;
  NumbersView? freeSpace;
  NumbersView? usedSpace = NumbersView('0');

  static zero() => RamUsageStat.fromMap({
        'capacity': '0',
        'freeBytes': '0',
        'usedBytes': '0',
        'freeSpace': '0',
        'usedSpace': '0',
      });

  Map<String, dynamic> toMap() => {
        'capacity': capacity,
        'freeBytes': freeBytes,
        'usedBytes': usedBytes,
        'freeSpace': freeSpace,
        'usedSpace': usedSpace,
      };

  static RamUsageStat fromMap(Map<String, dynamic> statMap) {
    return RamUsageStat()
      ..capacity = _toNv(statMap['capacity'])
      ..freeBytes = _toNv(statMap['freeBytes'])
      ..usedBytes = _toNv(statMap['usedBytes'])
      ..freeSpace = _toNv(statMap['freeSpace'])
      ..usedSpace = _toNv(statMap['usedSpace']);
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

/// TODO: there is more things like:
/// - type [ssd, hdd]
/// - system disk [true, false]
/// - formated [InGB]
/// - average response time [InMSs]
class DiskUsageStat {
  /// The Total Ram capacity
  String? capacity;
  String? readSpeed;
  String? writeSpeed;
  String? speed;
  String? freeSpace;
  String? usedSpace;

  static zero() => DiskUsageStat.fromMap({
        'readSpeed': '0',
        'writeSpeed': '0',
        'speed': '0',
        'freeSpace': '0',
        'usedSpace': '0',
      });

  Map<String, dynamic> toMap() => {
        'readSpeed': readSpeed,
        'writeSpeed': writeSpeed,
        'speed': speed,
        'freeSpace': freeSpace,
        'usedSpace': usedSpace,
      };

  static DiskUsageStat fromMap(Map<String, dynamic> statMap) {
    return DiskUsageStat()
      ..capacity = statMap['capacity']
      ..readSpeed = statMap['readSpeed']
      ..writeSpeed = statMap['writeSpeed']
      ..speed = statMap['speed']
      ..freeSpace = statMap['freeSpace']
      ..usedSpace = statMap['usedSpace'];
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

class NetUsageStat {
  NumbersView? uploadSpeed;
  NumbersView? downloadSpeed;
  NumbersView? netSpeed;
  NumbersView? bucket;
  NumbersView? uploadedData;
  NumbersView? downloadedData;
  NumbersView? totalTransfered;
  NumbersView? xenonRequests;
  NumbersView? xenonResponses;
  NumbersView? spiderRequests;
  NumbersView? spiderResponses;
  NumbersView? totalRequests;
  NumbersView? totalResponses;

  static zero() => NetUsageStat.fromMap({
        'uploadSpeed': '0',
        'downloadSpeed': '0',
        'netSpeed': '0',
        'bucket': '0',
        'uploadedData': '0',
        'downloadedData': '0',
        'totalTransfered': '0',
        'xenonRequests': '0',
        'xenonResponses': '0',
        'spiderRequests': '0',
        'spiderResponses': '0',
        'totalRequests': '0',
        'totalResponses': '0',
      });

  Map<String, dynamic> toMap() => {
        'uploadSpeed': uploadSpeed,
        'downloadSpeed': downloadSpeed,
        'netSpeed': netSpeed,
        'bucket': bucket,
        'uploadedData': uploadedData,
        'downloadedData': downloadedData,
        'totalTransfered': totalTransfered,
        'xenonRequests': xenonRequests,
        'xenonResponses': xenonResponses,
        'spiderRequests': spiderRequests,
        'spiderResponses': spiderResponses,
        'totalRequests': totalRequests,
        'totalResponses': totalResponses,
      };

  static NetUsageStat fromMap(Map<String, dynamic> statMap) {
    NetUsageStat _netUsageState = NetUsageStat();
    // print(statMap);
    _netUsageState.downloadSpeed = _toNv(statMap['downloadSpeed']);
    _netUsageState.uploadSpeed = _toNv(statMap['uploadSpeed']);
    _netUsageState.bucket = _toNv(statMap['bucket']);
    _netUsageState.uploadedData = _toNv(statMap['uploadedData']);
    _netUsageState.downloadedData = _toNv(statMap['downloadedData']);
    _netUsageState.xenonRequests = _toNv(statMap['xenonRequests']);
    _netUsageState.xenonResponses = _toNv(statMap['xenonResponses']);
    _netUsageState.spiderRequests = _toNv(statMap['spiderRequests']);
    _netUsageState.spiderResponses = _toNv(statMap['spiderResponses']);
    _netUsageState.totalRequests = _nvNullChk(_netUsageState.xenonRequests) +
        _nvNullChk(_netUsageState.spiderRequests);

    _netUsageState.netSpeed = (_nvNullChk(_netUsageState.downloadSpeed) +
        _nvNullChk(_netUsageState.uploadSpeed));
    // (int.tryParse(statMap['xenonRequests'] ?? '0')! +
    //         int.tryParse(statMap['spiderRequests'] ?? '0')!)
    //     .toString();
    _netUsageState.totalResponses = _nvNullChk(_netUsageState.xenonResponses) +
        _nvNullChk(_netUsageState.spiderResponses);

    // (int.tryParse(statMap['xenonResponses'] ?? '0')! +
    //         int.tryParse(statMap['spiderResponses'] ?? '0')!)
    //     .toString();
    _netUsageState.totalTransfered = _nvNullChk(_netUsageState.uploadedData) +
        _nvNullChk(_netUsageState.downloadedData);

    // (int.tryParse(statMap['uploadedData'] ?? '0')! +
    //         int.tryParse(statMap['downloadedData'] ?? '0')!)
    //     .toString();
    // print(_netUsageState.toString());
    return _netUsageState;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

T _nullChk<T>(dynamic value, dynamic defaultV) {
  if (value != null) {
    return value;
  } else {
    return defaultV;
  }
}

NumbersView _nvNullChk(NumbersView? value) {
  return _nullChk(value, NumbersView(0));
}

NumbersView _toNv(dynamic value) {
  return NumbersView(_nullChk(value, 0));
}


// class ServerStat {
//   ServerStat({
//     this.cpuUsage,
//     this.ramUsage,
//     this.netUsage,
//     this.diskUsage,
//   });

//   ServerStat.zero({
//     this.cpuUsage,
//     this.ramUsage,
//     this.netUsage,
//     this.diskUsage,
//   }) {
//     cpuUsage = CpuUsageStat();
//     ramUsage = RamUsageStat();
//     netUsage = NetUsageStat();
//     diskUsage = DiskUsageStat();
//   }

//   late CpuUsageStat? cpuUsage;
//   late RamUsageStat? ramUsage;
//   late NetUsageStat? netUsage;
//   late DiskUsageStat? diskUsage;

//   Map<String, dynamic> toMap() => {
//         'cu': cpuUsage?.toMap(),
//         'ru': ramUsage?.toMap(),
//         'du': diskUsage?.toMap(),
//         'nu': netUsage?.toMap(),
//       };

//   static ServerStat fromMap(Map<String, dynamic> insMap) {
//     return ServerStat(
//       cpuUsage: CpuUsageStat.fromMap(insMap['cu']),
//       ramUsage: RamUsageStat.fromMap(insMap['ru']),
//       netUsage: NetUsageStat.fromMap(insMap['nu']),
//       diskUsage: DiskUsageStat.fromMap(insMap['du']),
//     );
//   }
// }

// /// TODO: more data can be maintained
// /// - Name and module
// /// - threads Threads Number
// /// - process [Process Number]
// /// - up time [9:01:01]
// /// - L caches [128KB, 512KB, 3.0MB]
// /// - Virtualization [Enabled, Disabled]
// class CpuUsageStat {
//   String? usage = '0%';
//   // String? speed = '0 GHz';
//   String? frequency = '0 GHz';
//   String? coresNumber;
//   List<String>? coresUsage;

//   Map<String, dynamic> toMap() => {
//         'coresNumber': coresNumber,
//         'coresUsage': coresUsage,
//         'usage': usage,
//         'frequency': frequency,
//       };

//   static CpuUsageStat fromMap(Map<String, dynamic> statMap) {
//     return CpuUsageStat()
//       ..coresNumber = statMap['coresNumber']
//       ..coresUsage = statMap['coresUsage']
//       ..usage = statMap['usage']
//       ..frequency = statMap['frequency'];
//   }
// }

// /// TODO: more data can be maintained
// /// - gen of DDR
// /// - Speed in MHz
// /// - FormFactor
// /// - In use compressed
// /// - commited
// /// - cahed
// /// - paged & non paged pool
// class RamUsageStat {
//   RamUsageStat({
//     this.capacity,
//     this.freeBytes,
//     this.freeSpace,
//     this.usedBytes,
//     this.usedSpace,
//   });

//   /// The Total Ram capacity
//   String? capacity;
//   String? freeBytes;
//   String? usedBytes;
//   String? freeSpace;
//   String? usedSpace = '0%';

//   Map<String, dynamic> toMap() => {
//         'capacity': capacity,
//         'freeBytes': freeBytes,
//         'usedBytes': usedBytes,
//         'freeSpace': freeSpace,
//         'usedSpace': usedSpace,
//       };

//   static RamUsageStat fromMap(Map<String, dynamic> statMap) {
//     return RamUsageStat()
//       ..capacity = statMap['capacity']
//       ..freeBytes = statMap['freeBytes']
//       ..usedBytes = statMap['usedBytes']
//       ..freeSpace = statMap['freeSpace']
//       ..usedSpace = statMap['usedSpace'];
//   }
// }

// /// TODO: there is more things like:
// /// - type [ssd, hdd]
// /// - system disk [true, false]
// /// - formated [InGB]
// /// - average response time [InMSs]
// ///
// class DiskUsageStat {
//   /// The Total Ram capacity
//   String? capacity;
//   String? readSpeed;
//   String? writeSpeed;
//   String? speed;
//   String? freeSpace;
//   String? usedSpace;

//   Map<String, dynamic> toMap() => {
//         'readSpeed': readSpeed,
//         'writeSpeed': writeSpeed,
//         'speed': speed,
//         'freeSpace': freeSpace,
//         'usedSpace': usedSpace,
//       };

//   static DiskUsageStat fromMap(Map<String, dynamic> statMap) {
//     return DiskUsageStat()
//       ..capacity = statMap['capacity']
//       ..readSpeed = statMap['readSpeed']
//       ..writeSpeed = statMap['writeSpeed']
//       ..speed = statMap['speed']
//       ..freeSpace = statMap['freeSpace']
//       ..usedSpace = statMap['usedSpace'];
//   }
// }

// class NetUsageStat {
//   String? uploadSpeed;
//   String? downloadSpeed;
//   String? netSpeed;
//   String? bucket;
//   String? uploadedData;
//   String? downloadedData;
//   String? totalTransfered;

//   Map<String, dynamic> toMap() => {
//         'uploadSpeed': uploadSpeed,
//         'downloadSpeed': downloadSpeed,
//         'netSpeed': netSpeed,
//         'bucket': bucket,
//         'uploadedData': uploadedData,
//         'downloadedData': downloadedData,
//         'totalTransfered': totalTransfered,
//       };

//   static NetUsageStat fromMap(Map<String, dynamic> statMap) {
//     return NetUsageStat()
//       ..downloadSpeed = statMap['downloadSpeed']
//       ..uploadSpeed = statMap['uploadSpeed']
//       ..bucket = statMap['bucket']
//       ..netSpeed = statMap['netSpeed']
//       ..uploadedData = statMap['uploadedData']
//       ..downloadedData = statMap['downloadedData']
//       ..totalTransfered = statMap['totalTransfered'];
//   }
// }
