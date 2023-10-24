// ignore_for_file: library_private_types_in_public_api
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  var camera;

  void loadCamera() async {
    // Obtén una lista de las cámaras disponibles en el dispositivo.
    final cameras = await availableCameras();

    // Obtén una cámara específica de la lista de cámaras disponibles
    final firstCamera = cameras.first;

    camera = firstCamera;
  }

  double returnResponsiveWidth(context, double originalPercentValue) {
    return MediaQuery.of(context).size.width * originalPercentValue;
  }

  double returnResponsiveHeight(context, double originalPercentValue) {
    return MediaQuery.of(context).size.height * originalPercentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.upgrade),
            label: 'Subir',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Galería',
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: returnResponsiveWidth(context, 0.9),
            height: returnResponsiveHeight(context, 0.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color.fromARGB(255, 197, 197, 197),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: returnResponsiveHeight(context, 0.05)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.camera,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 50.0,
                  ),
                  label: const Text('Abrir cámara',
                      style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    loadCamera();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: returnResponsiveHeight(context, 0.05)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.archive,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 50.0,
                  ),
                  label: const Text('Abrir archivo',
                      style: TextStyle(fontSize: 30)),
                  onPressed: () {
                    print('Abrir archivo pulsado');
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
