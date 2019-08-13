import 'package:adibook/utils/common_function.dart';
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
CommonClass commonClass = new CommonClass();
  File img;
  Future image_picker_camera() async {
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future image_picker_gallary() async {
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
        backgroundColor: Color(commonClass.hexColor('#03D1BF')),
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
                            color: Color(
                              commonClass.hexColor('#03D1BF'),
                            ),
                            onPressed: () {
                              image_picker_camera();
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
                            color: Color(
                              commonClass.hexColor('#03D1BF'),
                            ),
                            onPressed: () {
                              image_picker_gallary();
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
