// import 'dart:convert';
// import 'dart:io';

// // import 'package:elogger/elogger.dart';
// extension on List<ServerJob> {
//   List<String> toStringList() {
//     return map<String>((serverJob) => serverJob.toString()).toList();
//   }
// }

// class Config {
//   Config.f();
//   bool state = false;
//   Config fromFile(String filePathFromTheCurrentDirectory) {
//     // stdout.write('Tring to find json config file.. @${Directory.current.path}\n');
//     var file = File(filePathFromTheCurrentDirectory);
//     // var _errFlag = false;
//     if (file.existsSync()) {
//       var jsonConfigurations = file.readAsStringSync();
//       var configurations = json.decode(jsonConfigurations);
//       // try {
//       port = configurations[ConfigConsts.port] is String
//           ? int.parse(configurations[ConfigConsts.port])
//           : configurations[ConfigConsts.port];
//       daemonPort = configurations[ConfigConsts.daemonPort] is String
//           ? int.parse(configurations[ConfigConsts.daemonPort])
//           : configurations[ConfigConsts.daemonPort];
//       host = configurations[ConfigConsts.host];
//       databaseUrl = configurations[ConfigConsts.databaseUrl];
//       databaseUser = configurations[ConfigConsts.databaseUser];
//       certFilePath = configurations[ConfigConsts.certFilePath];
//       webServePath = configurations[ConfigConsts.webServePath];
//       storageServePath = configurations[ConfigConsts.storageServePath];
//       databasePassword = configurations[ConfigConsts.databasePassword];
//       enabledChannels = _findJobs(configurations[ConfigConsts.enabledChannels]);
//       certPasswordFilePath = configurations[ConfigConsts.certPasswordFilePath];
//       name = configurations[ConfigConsts.name];
//       job = _findServerJob(configurations[ConfigConsts.job]);
//       stdout.writeln('Server Job is: $job');
//       spiderId = configurations[ConfigConsts.spiderId];
//       xenonId = configurations[ConfigConsts.xenonId];
//       center = configurations[ConfigConsts.center];
//       metaData = configurations[ConfigConsts.metaData];

//       // } catch (e) {
//       // _errFlag = true;
//       // Elogger.log(e, err: true);
//       // }
//       // if (!_errFlag) {
//       state = true;
//       // stdout.write('Done @${Directory.current.path}\n');
//       // } else {
//       // stdout.write('Not done @${Directory.current.path}\n');
//       // }
//       return this;
//     } else {
//       return createNewOne();
//     }
//   }

//   Config reWriteOptions(
//     Map<String, dynamic> newDataMap,
//     String filePath,
//   ) {
//     var file = File(filePath);
//     var _writeDataErrFlag = false;
//     var _readDataErrFlag = false;
//     if (file.existsSync()) {
//       var jsonConfigurations = file.readAsStringSync();
//       var configurations = json.decode(jsonConfigurations);
//       try {
//         if (newDataMap[ConfigConsts.spiderId] != null &&
//             configurations[ConfigConsts.spiderId] !=
//                 newDataMap[ConfigConsts.spiderId]) {
//           configurations[ConfigConsts.spiderId] =
//               newDataMap[ConfigConsts.spiderId];
//         }
//         if (newDataMap[ConfigConsts.xenonId] != null &&
//             configurations[ConfigConsts.xenonId] !=
//                 newDataMap[ConfigConsts.xenonId]) {
//           configurations[ConfigConsts.xenonId] =
//               newDataMap[ConfigConsts.xenonId];
//         }
//         if (newDataMap[ConfigConsts.name] != null &&
//             configurations[ConfigConsts.name] !=
//                 newDataMap[ConfigConsts.name]) {
//           configurations[ConfigConsts.name] = newDataMap[ConfigConsts.name];
//         }
//         if (newDataMap[ConfigConsts.job] != null &&
//             configurations[ConfigConsts.job] != newDataMap[ConfigConsts.job]) {
//           configurations[ConfigConsts.job] = newDataMap[ConfigConsts.job];
//         }
//         if (newDataMap[ConfigConsts.center] != null &&
//             configurations[ConfigConsts.center] !=
//                 newDataMap[ConfigConsts.center]) {
//           configurations[ConfigConsts.center] = newDataMap[ConfigConsts.center];
//         }
//         if (newDataMap[ConfigConsts.metaData] != null &&
//             configurations[ConfigConsts.metaData] !=
//                 newDataMap[ConfigConsts.metaData]) {
//           configurations[ConfigConsts.metaData] =
//               newDataMap[ConfigConsts.metaData];
//         }
//         if (newDataMap[ConfigConsts.port] != null &&
//             configurations[ConfigConsts.port] !=
//                 newDataMap[ConfigConsts.port]) {
//           configurations[ConfigConsts.port] = newDataMap[ConfigConsts.port];
//         }
//         if (newDataMap[ConfigConsts.daemonPort] != null &&
//             configurations[ConfigConsts.daemonPort] !=
//                 newDataMap[ConfigConsts.daemonPort]) {
//           configurations[ConfigConsts.daemonPort] =
//               newDataMap[ConfigConsts.daemonPort];
//         }
//         if (newDataMap[ConfigConsts.host] != null &&
//             configurations[ConfigConsts.host] !=
//                 newDataMap[ConfigConsts.host]) {
//           configurations[ConfigConsts.host] = newDataMap[ConfigConsts.host];
//         }
//         if (newDataMap[ConfigConsts.databaseUrl] != null &&
//             configurations[ConfigConsts.databaseUrl] !=
//                 newDataMap[ConfigConsts.databaseUrl]) {
//           configurations[ConfigConsts.databaseUrl] =
//               newDataMap[ConfigConsts.databaseUrl];
//         }
//         if (newDataMap[ConfigConsts.databaseUser] != null &&
//             configurations[ConfigConsts.databaseUser] !=
//                 newDataMap[ConfigConsts.databaseUser]) {
//           configurations[ConfigConsts.databaseUser] =
//               newDataMap[ConfigConsts.databaseUser];
//         }
//         if (newDataMap[ConfigConsts.certFilePath] != null &&
//             configurations[ConfigConsts.certFilePath] !=
//                 newDataMap[ConfigConsts.certFilePath]) {
//           configurations[ConfigConsts.certFilePath] =
//               newDataMap[ConfigConsts.certFilePath];
//         }
//         if (newDataMap[ConfigConsts.webServePath] != null &&
//             configurations[ConfigConsts.webServePath] !=
//                 newDataMap[ConfigConsts.webServePath]) {
//           configurations[ConfigConsts.webServePath] =
//               newDataMap[ConfigConsts.webServePath];
//         }
//         if (newDataMap[ConfigConsts.storageServePath] != null &&
//             configurations[ConfigConsts.storageServePath] !=
//                 newDataMap[ConfigConsts.storageServePath]) {
//           configurations[ConfigConsts.storageServePath] =
//               newDataMap[ConfigConsts.storageServePath];
//         }
//         if (newDataMap[ConfigConsts.databasePassword] != null &&
//             configurations[ConfigConsts.databasePassword] !=
//                 newDataMap[ConfigConsts.databasePassword]) {
//           configurations[ConfigConsts.databasePassword] =
//               newDataMap[ConfigConsts.databasePassword];
//         }
//         if (newDataMap[ConfigConsts.certPasswordFilePath] != null &&
//             configurations[ConfigConsts.certPasswordFilePath] !=
//                 newDataMap[ConfigConsts.certPasswordFilePath]) {
//           configurations[ConfigConsts.certPasswordFilePath] =
//               newDataMap[ConfigConsts.certPasswordFilePath];
//         }
//         if (newDataMap[ConfigConsts.enabledChannels] != null &&
//             configurations[ConfigConsts.enabledChannels] !=
//                 newDataMap[ConfigConsts.enabledChannels]) {
//           configurations[ConfigConsts.enabledChannels] =
//               newDataMap[ConfigConsts.enabledChannels];
//         }
//       } catch (e) {
//         _readDataErrFlag = true;
//         // Elogger.log(e, err: true);
//       }
//       if (!_readDataErrFlag) {
//         state = true;
//         // stdout.write('Reading Data Done @$filePath\n');
//       } else {
//         // stdout.write('Reading Data Not done or error @$filePath\n');
//       }

//       var newConfigurations = configurations;
//       try {
//         var newJsonConfigurations = json.encode(newConfigurations);
//         file.writeAsStringSync(newJsonConfigurations);
//       } catch (e) {
//         _writeDataErrFlag = true;
//         // Elogger.log(e, err: true);
//       }
//       if (!_writeDataErrFlag) {
//         state = true;
//         // stdout.write('Writing Data Done @$filePath\n');
//       } else {
//         // stdout.write('Writing Data Not done or error @$filePath\n');
//       }
//       return this;
//     } else {
//       // stdout.write('An exists config file not found\n Creating new one @$filePath..');
//       return createNewOneFromData(newDataMap);
//     }
//   }

//   Config createNewOneFromData(Map<String, dynamic> dataMap) {
//     // stdout.write('Creating new one.. @${Directory.current.path}\n');
//     var file = File(ConfigConsts.jsonFileName);
//     var _errFlag = false;
//     try {
//       var configurations = json.encode(dataMap);
//       file.writeAsStringSync(configurations);
//     } catch (e) {
//       _errFlag = true;
//       // Elogger.log(e, err: true);
//     }
//     if (!_errFlag) {
//       state = true;
//       // stdout.write('Done\n @${Directory.current.path}');
//     } else {
//       // stdout.write('Not done\n @${Directory.current.path}');
//     }
//     return fromFile(ConfigConsts.jsonFileName);
//   }

//   Config createNewOne() {
//     // stdout.write('Creating new one.. @${Directory.current.path}\n');
//     var file = File(ConfigConsts.jsonFileName);
//     var _errFlag = false;
//     try {
//       var configurations = json.encode(defaultConfigurations);
//       file.writeAsStringSync(configurations);
//     } catch (e) {
//       _errFlag = true;
//       // Elogger.log(e, err: true);
//     }
//     if (!_errFlag) {
//       state = true;
//       // stdout.write('Writing Data done Successfuly @${Directory.current.path}\n');
//     } else {
//       // stdout.write('Writing Data failur @${Directory.current.path}\n');
//     }
//     return fromFile(file.path);
//   }

//   String? name;
//   late ServerJob job;
//   String? center;
//   String? metaData;
//   String? spiderId;
//   String? xenonId;
//   int? port;
//   int? daemonPort;
//   String? host;
//   String? databaseUrl;
//   String? databaseUser;
//   String? databasePassword;
//   String? certFilePath;
//   String? certPasswordFilePath;
//   String? webServePath;
//   String? storageServePath;
//   List<ServerJob>? enabledChannels;

//   /// new try ports -- ports to try again in it - or `tryForAll` mode to declarative try

//   Config(
//     this.name,
//     this.job,
//     this.center,
//     this.metaData,
//     this.port,
//     this.daemonPort,
//     this.host,
//     this.databaseUrl,
//     this.databaseUser,
//     this.databasePassword,
//     this.webServePath,
//     this.certFilePath,
//     this.storageServePath,
//     this.certPasswordFilePath,
//     this.enabledChannels,
//   );

//   Map<String, dynamic> asMap() => {
//         ConfigConsts.name: name,
//         ConfigConsts.center: center,
//         ConfigConsts.metaData: metaData,
//         ConfigConsts.job: job.toString(),
//         ConfigConsts.daemonPort: daemonPort,
//         ConfigConsts.port: port,
//         ConfigConsts.host: host,
//         ConfigConsts.databaseUrl: databaseUrl,
//         ConfigConsts.databaseUser: databaseUser,
//         ConfigConsts.databasePassword: databasePassword,
//         ConfigConsts.certFilePath: certFilePath,
//         ConfigConsts.webServePath: webServePath,
//         ConfigConsts.storageServePath: storageServePath,
//         ConfigConsts.enabledChannels: enabledChannels?.toStringList(),
//         ConfigConsts.certPasswordFilePath: certPasswordFilePath
//       };
// }

// const Map<String, dynamic> defaultConfigurations = {
//   ConfigConsts.xenonId: null,
//   ConfigConsts.spiderId: null,
//   ConfigConsts.name: 'Xenon Server',
//   ConfigConsts.center: null,
//   ConfigConsts.metaData: null,
//   ConfigConsts.job: 23029,
//   ConfigConsts.port: 23029,
//   ConfigConsts.daemonPort: 23028,
//   ConfigConsts.host: '0.0.0.0',
//   ConfigConsts.databaseUrl: null,
//   ConfigConsts.databaseUser: null,
//   ConfigConsts.databasePassword: null,
//   ConfigConsts.webServePath: '/',
//   ConfigConsts.storageServePath: '/',
//   ConfigConsts.enabledChannels: ['all'],
//   ConfigConsts.certFilePath: null,
//   ConfigConsts.certPasswordFilePath: null,
//   // accepted web file request
//   // accepted web dirs request
// };

// class ConfigConsts {
//   static const String name = 'name';

//   /// The Main Server
//   static const String center = 'center';
//   static const String metaData = 'metaData';
//   static const String job = 'job';
//   static const String port = 'port';
//   static const String spiderId = 'spiderId';
//   static const String xenonId = 'xenonId';
//   static const String daemonPort = 'daemonPort';
//   // static const String observerPort = 'observerPort';
//   static const String host = 'host';
//   static const String databaseUrl = 'databaseUrl';
//   static const String databaseUser = 'databaseUser';
//   static const String certFilePath = 'certFilePath';
//   static const String webServePath = 'webServePath';
//   static const String storageServePath = 'storageServePath';
//   static const String enabledChannels = 'enabledChannels';
//   static const String databasePassword = 'databasePassword';
//   static const String certPasswordFilePath = 'certPasswordFilePath';

//   static const String jsonFileName = 'config.json';
// }

// enum ServerJob {
//   /// Functions Server uses any types of processors
//   functions, // 1

//   /// Functions Server uses gpu processors
//   computing, // 2

//   /// Database Server
//   database, // 3

//   /// Observer Server recording other servers log and analyzes it
//   /// and provides the stat and other servers runtime data
//   observer, // 4 // Main job has it's own channel

//   /// Storage Server (Blobs Database)
//   storage, // 5

//   /// Backup Server is a main channel has different functions and methods
//   /// to controle backup service
//   backup, // 6 // Main job has it's own channel

//   /// The normal is like a normal user runs the server in auto mode
//   normal, // 7 // Main job has it's own channel

//   /// Indexer Server saves indexes that can provied fast indexing serviecs
//   indexer, // 8 // Main job has it's own channel

//   /// Multi Channel Server indicates to the mutli channel
//   /// NOTE: currently it has no
//   mutli, // 9 // Main job has it's own channel

//   /// Proxy Server has it's main channel for forwarding requests and responses
//   /// and keeps the data and more...
//   proxy, // 10 // Main job has it's own channel

//   /// Main server is our compass and navigator, forwards the requests
//   /// after some checks and can provide authority service,
//   main, // 11 // Main job has it's own channel

//   /// Auth Sevrer that provide tokens
//   auth, // 12

//   /// Web Server serves web files
//   /// NOTE: it may need to enable mutli channel if website requires
//   /// to connect to xenon or other spider services
//   web, // 13

//   /// AI Server backed with computing services that power the AI computing
//   ia, // 14
// }

// findServerJob(String jobName) => _findServerJob(jobName);

// ServerJob _findServerJob(String jobName) {
//   switch (jobName) {
//     case 'ServerJob.functions': // 1
//       return ServerJob.functions;
//     case 'ServerJob.auth': // 2
//       return ServerJob.auth;
//     case 'ServerJob.computing': // 3
//       return ServerJob.computing;
//     case 'ServerJob.database': // 4
//       return ServerJob.database;
//     case 'ServerJob.observer': // 5
//       return ServerJob.observer;
//     case 'ServerJob.storage': // 6
//       return ServerJob.storage;
//     case 'ServerJob.backup': // 7
//       return ServerJob.backup;
//     case 'ServerJob.normal': // 8
//       return ServerJob.normal;
//     case 'ServerJob.mutli': // 9
//       return ServerJob.indexer;
//     case 'ServerJob.index': // 10
//       return ServerJob.mutli;
//     case 'ServerJob.main': // 11
//       return ServerJob.main;
//     case 'ServerJob.web': // 12
//       return ServerJob.web;
//     case 'ServerJob.ia': // 13
//       return ServerJob.ia;
//     case 'ServerJob.proxy': // 14
//       return ServerJob.proxy;
//     default:
//       return ServerJob.normal;
//   }
// }

// List<ServerJob> _findJobs(List<String> serverJobs) {
//   return serverJobs.map<ServerJob>(_findServerJob).toList();
// }
