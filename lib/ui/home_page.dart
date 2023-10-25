// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/ui/take_picture.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  String imagePath;
  HomePage({super.key, required this.imagePath});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List<String> listImages = [];
  bool _pickImage = false;
  int _selectedIndex = 0;
  bool finishedLoad = false;

  double returnResponsiveWidth(context, double originalPercentValue) {
    return MediaQuery.of(context).size.width * originalPercentValue;
  }

  double returnResponsiveHeight(context, double originalPercentValue) {
    return MediaQuery.of(context).size.height * originalPercentValue;
  }

  void handleNavigateTapToTakePicture(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
        CupertinoPageRoute(builder: (_) => TakePicture(camera: firstCamera)));
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 30), () {
      setState(() {
        finishedLoad = true;
      });
    });
    listImages.add(
        "https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1");
    listImages.add(
        "https://images.pexels.com/photos/147411/italy-mountains-dawn-daybreak-147411.jpeg?auto=compress&cs=tinysrgb&w=1600");
    listImages.add(
        "https://images.pexels.com/photos/808465/pexels-photo-808465.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1");
    listImages.add(
        "https://images.pexels.com/photos/675764/pexels-photo-675764.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1");
    listImages.add(
        "https://images.pexels.com/photos/2387418/pexels-photo-2387418.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1");
  }

  Future pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    var newImagePath = '';
    if (pickedFile != null) {
      newImagePath = File(pickedFile.path).path;
      _pickImage = true;
    }

    setState(() {
      widget.imagePath = newImagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: returnResponsiveWidth(context, 0.9),
            height: returnResponsiveHeight(context, 0.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(255, 197, 197, 197),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              getImage(),
              getName(),
            ]),
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
                    handleNavigateTapToTakePicture(context);
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
                    pickImage();
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
      loadingGallery(context),
    ];

    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget loadingGallery(BuildContext context) {
    return finishedLoad
        ? Padding(
            padding:
                EdgeInsets.only(top: returnResponsiveHeight(context, 0.05)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: returnResponsiveWidth(context, 0.9),
                  height: returnResponsiveHeight(context, 0.9),
                  child: ListView.builder(
                    itemCount: listImages.length,
                    itemBuilder: ((context, index) {
                      return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          margin: const EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Column(
                              children: <Widget>[
                                FadeInImage(
                                  image: NetworkImage(listImages[index]),
                                  placeholder:
                                      const AssetImage('assets/loading.gif'),
                                  fit: BoxFit.cover,
                                  height: 260,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(listImages[index]),
                                )
                              ],
                            ),
                          ));
                    }),
                  ),
                )
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget getImage() {
    Widget result;
    if (widget.imagePath == '') {
      result = const Text('Selecciona una imagen',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30));
    } else {
      result = Image.file(
        File(widget.imagePath),
        height: returnResponsiveHeight(context, 0.4),
      );
    }
    return result;
  }

  Widget getName() {
    String path = widget.imagePath;
    if (_pickImage) {
      return Padding(
        padding: EdgeInsets.only(top: returnResponsiveHeight(context, 0.02)),
        child: Text(path.split('/')[path.split('/').length - 1],
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      );
    } else {
      return const Text("",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
