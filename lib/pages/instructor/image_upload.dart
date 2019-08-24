import 'package:adibook/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageUpload extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImageUploadState();
  }
}

class ImageUploadState extends State<ImageUpload> {
  File img;
  Future imagePickerCamera() async {
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future imagePickerGallary() async {
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
        backgroundColor: AppTheme.appThemeColor,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Wrap(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            width: 320.0,
                            height: 220.0,
                            child: Center(
                              child:      
                                  ClipRRect(
                                   borderRadius: BorderRadius.circular(5.0),
                                    child: img == null? 
                                    Text("No Image",style: TextStyle(fontWeight: FontWeight.bold),)                                
                                   : Image.file(img),
                                  )
                            )),
                      ]),
                  Container(
                    padding: EdgeInsets.only(top: 13.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: 200.0,
                          height: 50.0,
                          child: RaisedButton(
                            color: AppTheme.appThemeColor,
                            onPressed: () {
                              imagePickerCamera();
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "Upload Image From Camera",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 13.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: 200.0,
                          height: 50.0,
                          child: RaisedButton(
                            color: AppTheme.appThemeColor,
                            onPressed: () {
                              imagePickerGallary();
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "Upload Image From Gallary",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
