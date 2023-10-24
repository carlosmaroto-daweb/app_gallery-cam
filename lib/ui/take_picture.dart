import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/ui/home_page.dart';

// ignore: must_be_immutable
class TakePicture extends StatefulWidget {
  TakePicture({super.key, required this.camera});
  // ignore: prefer_typing_uninitialized_variables
  var camera;

  @override
  // ignore: library_private_types_in_public_api
  _TakePicture createState() => _TakePicture();
}

class _TakePicture extends State<TakePicture> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  // ignore: prefer_typing_uninitialized_variables
  var image;

  double returnResponsiveHeight(context, double originalPercentValue) {
    return MediaQuery.of(context).size.height * originalPercentValue;
  }

  void handleNavigateTapToHomePage(BuildContext context) async {
    Navigator.of(context).push(
        CupertinoPageRoute(builder: (_) => HomePage(imagePath: image.path)));
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: returnResponsiveHeight(context, 0.05)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    image = await _controller.takePicture();
                    if (!mounted) return;
                    handleNavigateTapToHomePage(context);
                  } catch (e) {
                    // ignore: avoid_print
                    print(e);
                  }
                },
                child: const Icon(Icons.camera_alt),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
