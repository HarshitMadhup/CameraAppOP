import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'ImageView.dart';
import 'VideoView.dart';
import 'package:gallery_saver_safety/gallery_saver_safety.dart';

List<CameraDescription>? cameras;

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  Future<void>? cameraValue;
  bool isRecording = false;
  XFile? videoFile;
  bool isCameraFront = true;
  bool flash = false;
  double transform = 0;
  double zoom = 0.0;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras![0], ResolutionPreset.high);
    cameraValue = _cameraController!.initialize();
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  Widget _cameraPreview() => FutureBuilder(
        future: cameraValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              height: MediaQuery.of(context).size.width * 16 / 9,
              width: MediaQuery.of(context).size.width,
              child: CameraPreview(_cameraController!),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );

  void takePhoto(BuildContext context) async {
    final path = join((await getApplicationDocumentsDirectory()).path,
        "${DateTime.now()}.png");
    XFile picture = await _cameraController!.takePicture();
    picture.saveTo(path);
    GallerySaver.saveImage(
      picture.path,
    ).then((bool? success) {
      print("success");
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => ImageView(
          path: path,
        ),
      ),
    );
  }

  // Future<String> takePicture() async {
  //   if (!_cameraController!.value.isInitialized) {
  //     showInSnackBar('Error: select a camera first.');
  //     return null;
  //   }
  //   final PermissionStatus writeAccess = await Permission.storage.request();

  //   Directory extDir;
  //   // if user disagrees to allow storage access the use app storage
  //   if (writeAccess.isGranted) {
  //     extDir = await getExternalStorageDirectory();
  //   } else {
  //     extDir = await getApplicationDocumentsDirectory();
  //   }
  //   final String dirPath = '${extDir.path}/Pictures/pics';
  //   await new Directory(dirPath).create(recursive: true);
  //   final String filePath = '$dirPath/${timestamp()}.jpg';

  //   if (_cameraController!.value.isTakingPicture) {
  //     // A capture is already pending, do nothing.
  //     return null;
  //   }

  //   try {
  //     await _ccameraController!takePicture(filePath);
  //   } on CameraException catch (e) {
  //     print('Exception -> $e');
  //     return null;
  //   }
  //   final File makeFile = new File(filePath);
  //   setState(() {
  //     imageList.add(makeFile.absolute.path);
  //   });
  //   return filePath;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(children: [
          Stack(children: [
            _cameraPreview(),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.document_scanner_rounded,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        flash = !flash;
                      });
                      flash
                          ? _cameraController!.setFlashMode(FlashMode.torch)
                          : _cameraController!.setFlashMode(FlashMode.off);
                    },
                    child: flash
                        ? Icon(
                            Icons.flash_on,
                            color: Colors.white,
                            size: 30.0,
                          )
                        : Icon(
                            Icons.flash_off,
                            color: Colors.white,
                            size: 30.0,
                          ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: MediaQuery.of(context).size.shortestSide / 4,
              child: Slider(
                value: zoom,
                activeColor: Colors.black,
                inactiveColor: Colors.white,
                onChanged: (value) {
                  value = value * 10;
                  if (value <= 8.0 && value >= 1.0) {
                    _cameraController!.setZoomLevel(value);
                  }
                  setState(() {
                    zoom = value / 10;
                  });
                },
              ),
            ),
          ]),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          border: Border.all(width: 3.0, color: Colors.white),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171__340.jpg")),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onLongPress: () async {
                        await _cameraController!.startVideoRecording();
                        setState(() {
                          isRecording = true;
                        });
                      },
                      onLongPressUp: () async {
                        XFile videoPath =
                            await _cameraController!.stopVideoRecording();
                        setState(() {
                          isRecording = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => VideoView(
                              path: videoPath.path,
                            ),
                          ),
                        );
                      },
                      onTap: () {
                        if (!isRecording) {
                          takePhoto(context);
                        }
                      },
                      child: isRecording
                          ? Icon(
                              Icons.radio_button_on,
                              color: Colors.red,
                              size: 80.0,
                            )
                          : Icon(
                              Icons.panorama_fish_eye_outlined,
                              color: Colors.white,
                              size: 80.0,
                            ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          isCameraFront = !isCameraFront;
                          transform = transform + pi;
                        });
                        int cameraPos = isCameraFront ? 0 : 1;
                        _cameraController = CameraController(
                            cameras![cameraPos], ResolutionPreset.high);
                        cameraValue = _cameraController!.initialize();
                      },
                      child: Icon(
                        Icons.flip_camera_android,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Hold for the Video, Tap for the Photo",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
