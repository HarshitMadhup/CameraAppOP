
// import 'dart:io';

// import 'package:flutter/material.dart';

// import 'package:permission_handler/permission_handler.dart';

// class Utils {
//   static Future<bool> checkWritePermission() async {

//     if(Platform.isIOS){
//       return false;
//     }
//     bool permission = false;
//     await Permission.

//         .checkPermission(Permission.WriteExternalStorage)
//         .then((bool checkOkay) {
//       if (!checkOkay) {
//         SimplePermissions
//             .requestPermission(Permission.WriteExternalStorage)
//             .then((bool okDone) {
//           if (okDone) {
//             permission = true;
//           }
//         });
//       } else {
//         permission = true;
//       }
//     });
//     return permission;
//   }
// }