//import 'package:chat_app1/modals/userModals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/modals/userModals.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class OwnerProfile extends StatefulWidget {
  final UserModal userModal;
  final User firebaseUser;

  const OwnerProfile({
    super.key,
    required this.userModal,
    required this.firebaseUser,
  });

  @override
  State<OwnerProfile> createState() => _OwnerProfile();
}

class _OwnerProfile extends State<OwnerProfile> {
  File? pickedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 3, 110, 76),
          title: Text(
            widget.userModal.fullname.toString(),
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: false,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Stack(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 110,
                  backgroundImage: NetworkImage(
                    widget.userModal.profilepic.toString(),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 155,
              left: 260,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20.0))),
                      builder: (BuildContext context) {
                        return Container(
                          height: 300,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 7,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Profile photo",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        // fontSize: MediaQuery.of(context).size.height.*.0.5
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .5,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.grey,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: InkWell(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                await getImage(
                                                    ImageSource.camera);
                                              },
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 30,
                                                color: Color.fromARGB(
                                                    255, 3, 110, 76),
                                              ),
                                            ),
                                            radius: 39,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Camera",
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.grey,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: InkWell(
                                              onTap: () async {
                                                await getImage(
                                                    ImageSource.gallery);
                                                Navigator.pop(context);
                                              },
                                              child: Icon(
                                                Icons.browse_gallery_rounded,
                                                size: 30,
                                                color: Color.fromARGB(
                                                    255, 3, 110, 76),
                                              ),
                                            ),
                                            radius: 39,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Gallery",
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.grey,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Icon(
                                                Icons.cancel,
                                                size: 33,
                                                color: Color.fromARGB(
                                                    255, 3, 110, 76),
                                              ),
                                            ),
                                            radius: 39,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Cancel",
                                          style: TextStyle(fontSize: 20),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                child: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 13, 186, 131),
                  radius: 30,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 1.0,
                  height: MediaQuery.of(context).size.width * .3,
                  color: Colors.white,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Column(children: [
                          Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.black,
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: ,
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * .023,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              //fontWeight: FontWeight.w300,
                            ),
                          ),
                          // SizedBox(
                          //   height: 3,
                          // ),
                          Text(
                            widget.userModal.fullname.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "This is not your username or pin.This name",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * .016,
                              color: Color.fromARGB(255, 120, 118, 118),
                            ),
                          ),
                          Text(
                            "will be visible to your WhatsApp contacts.",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 120, 118, 118),
                            ),
                          )
                        ],
                      ),
                    ],
                  ))
            ],
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.height * .46,
                height: 100,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.info,
                            size: 30,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * .025,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "If you don't fight,you can't win.",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * .022),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 27,
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 90,
                color: Colors.white,
                child: Row(children: [
                  SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 30,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Phone",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.050,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "+919766776686",
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.width * 0.048),
                      )
                    ],
                  )
                ]),
              )
            ],
          )
        ],
      ),
    );
  }

  Future getImage(ImageSource sources) async {
    try {
      final image = await ImagePicker().pickImage(source: sources);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        pickedImage = imageTemporary;
      });
    } on PlatformException {
      // ignore: avoid_print
      print("failed to pick image");
    }
  }
}
