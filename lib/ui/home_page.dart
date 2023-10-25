// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String imagePath = '';
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
      imagePath = newImagePath;
    });
  }

  Future takePicture() async {
    final takePicture =
        await ImagePicker().pickImage(source: ImageSource.camera);
    var newImagePath = '';
    if (takePicture != null) {
      newImagePath = File(takePicture.path).path;
      _pickImage = false;
    }

    setState(() {
      imagePath = newImagePath;
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
                    takePicture();
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
    if (imagePath == '') {
      result = const Text('Selecciona una imagen',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30));
    } else {
      result = Image.file(
        File(imagePath),
        height: returnResponsiveHeight(context, 0.4),
      );
    }
    return result;
  }

  Widget getName() {
    if (_pickImage) {
      return Padding(
        padding: EdgeInsets.only(top: returnResponsiveHeight(context, 0.02)),
        child: Text(imagePath.split('/')[imagePath.split('/').length - 1],
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
