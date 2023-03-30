import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  start() async {
    //lancer au
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      PermissionStatus photoPermission = await Permission.photos.status;
      checkStatusPhotos(photoPermission);
    } else {
      PermissionStatus storagePermission = await Permission.storage.status;
      checkStatusStorage(storagePermission);
    }
  }

  Future<Permission> checkStatusPhotos(
      PermissionStatus permissionStatus) async {
    switch (permissionStatus) {
      case PermissionStatus.permanentlyDenied:
        return Future.error("L'accès aux photos est réfusé");
      case PermissionStatus.denied:
        return Future.error("L'accès aux photos est réfusé");
      case PermissionStatus.limited:
        return await Permission.photos
            .request()
            .then((value) => checkStatusPhotos(value));
      case PermissionStatus.restricted:
        return await Permission.photos
            .request()
            .then((value) => checkStatusPhotos(value));
      case PermissionStatus.granted:
        return await Permission.photos
            .request()
            .then((value) => checkStatusPhotos(value));
      default:
        return Future.error("Aucune permission indiqué");
    }
  }

  Future<PermissionStatus> checkStatusStorage(
      PermissionStatus permissionStatus) async {
    switch (permissionStatus) {
      case PermissionStatus.permanentlyDenied:
        return Future.error("L'accès aux photos est réfusé");
      case PermissionStatus.denied:
        return Future.error("L'accès aux photos est réfusé");
      case PermissionStatus.limited:
        return await Permission.storage
            .request()
            .then((value) => checkStatusStorage(value));
      case PermissionStatus.restricted:
        return await Permission.storage
            .request()
            .then((value) => checkStatusStorage(value));
      case PermissionStatus.granted:
        return await Permission.storage
            .request()
            .then((value) => checkStatusStorage(value));
      default:
        return Future.error("Aucune permission indiqué");
    }
  }
}
