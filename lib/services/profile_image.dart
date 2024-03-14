import 'dart:io';

import 'package:miaged/theme/light_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilImage extends StatefulWidget {
  const ProfilImage(
      {Key? key, required this.imageBlob, required this.imageBlobBackRef})
      : super(key: key);
  final Function(File) imageBlobBackRef;
  final String imageBlob;

  @override
  _ProfilImageState createState() => _ProfilImageState();
}

class _ProfilImageState extends State<ProfilImage> {
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  dynamic _pickImageError;

  final ImagePicker _picker = ImagePicker();

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      setState(() {
        _imageFile = pickedFile;

        if (!kIsWeb) {
          widget.imageBlobBackRef(File(_imageFileList![0].path));
        }
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
          child: Stack(children: [
        _previewImages(),
        Positioned(
          bottom: 0,
          right: 4,
          child: buildEditIcon(LightColor.red),
        ),
      ])),
    );
  }

  Widget _previewImages() {
    //ImageProvider pour le cercle
    ImageProvider<Object> imageWidget =
        const AssetImage('assets/defaultPerson.png');

    if (widget.imageBlob.isNotEmpty && widget.imageBlob != "") {
      imageWidget = Image.network(widget.imageBlob).image;
    } else {
      //obligé de le set une seconde fois a cause d'un bug
      imageWidget = const AssetImage('assets/defaultPerson.png');
    }

    if (_imageFileList != null) {
      final path = _imageFileList![0].path;

      if (kIsWeb) {
        imageWidget = NetworkImage(path);
      } else {
        imageWidget = FileImage(File(path));
      }
      return buildImage(imageWidget);
    } else if (_pickImageError != null) {
      return buildImage(imageWidget);
    } else {
      return buildImage(imageWidget);
    }
  }

  //widget image
  Widget buildImage(ImageProvider image) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 100,
          height: 100,
          child: InkWell(onTap: () {
            !kIsWeb
                ? _showModal()
                : _onImageButtonPressed(ImageSource.gallery, context: context);
          }),
        ),
      ),
    );
  }

  //show modal choice : camera or gallery for android user
  Future<void> _showModal() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 100,
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        _onImageButtonPressed(ImageSource.camera,
                            context: context);
                        Navigator.pop(context);
                      },
                      child: const Text('Camera'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        _onImageButtonPressed(ImageSource.gallery,
                            context: context);

                        Navigator.pop(context);
                      },
                      child: const Text('Gallery'),
                    ),
                  ),
                ]),
          ),
        );
      },
    );
  }

  //widget icon edit return buildCircle
  Widget buildEditIcon(Color color) => buildCircle(
        color: LightColor.black,
        all: 1,
        child: buildCircle(
          color: color,
          all: 7,
          child: const Icon(
            Icons.more_horiz,
            color: Colors.white,
            size: 15,
          ),
        ),
      );

  //widget cercle pour icon
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
