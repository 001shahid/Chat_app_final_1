import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/modals/UIHelper.dart';
import 'package:flutter_application_1/modals/userModals.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  final UserModal userModal;
  final User firebaseUser;

  const CompleteProfile(
      {super.key, required this.userModal, required this.firebaseUser});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  File? pickedImage;
  TextEditingController fullNameController = TextEditingController();
  void checkValues() {
    String fullname = fullNameController.text.trim();
    if (fullname == "" || pickedImage == null) {
      UIHelper.showAlertDialog(context, "Incomplete data",
          "Please fill all the fields and upload a profile");
      //print("Please fill all the fields");
    } else {
      // debugPrint("photo uploaded!");
      // log("Uploading Data.. ");
      uploadData();
    }
  }

  void uploadData() async {
    UIHelper.showLoadingDialog(context, "Uploading Image..");
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepicture")
        .child(widget.userModal.uid.toString())
        .putFile(pickedImage!);
    debugPrint(pickedImage.toString());
    TaskSnapshot snapshot = await uploadTask;
    //passing fullname and imageurl
    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullname = fullNameController.text.trim();
    //update fullname and imageurl
    widget.userModal.fullname = fullname;
    widget.userModal.profilepic = imageUrl;
    //collecting data in firebase
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModal.uid)
        .set(widget.userModal.toMap())
        .then((value) {
      debugPrint("datauploaded!");
      //log("Data uploaded!");
      Navigator.popUntil(context, (route) => route.isFirst);

      //print("Data uploaded!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return HomePage(
          userModal: widget.userModal,
          firebaseUser: widget.firebaseUser,
        );
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Complete Profile"),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    builder: (BuildContext context) {
                      return Container(
                        height: 300,
                        child: Column(
                          children: [
                            const SizedBox(
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
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Profile photo",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: 200,
                                  ),
                                  Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
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
                                              getImage(ImageSource.camera);
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Camera",
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
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
                                              getImage(ImageSource.gallery);
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
                                        "Gallery",
                                        style: TextStyle(fontSize: 20),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Text(
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
              padding: EdgeInsets.all(0),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: pickedImage != null
                    ? FileImage(
                        pickedImage!) // Use FileImage to create an ImageProvider from the File
                    : null, // Set backgroundImage to null when _image is null
                child: pickedImage == null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            SizedBox(
              height: 20,
            ),
            CupertinoButton(
              child: Text("Submit"),
              onPressed: () {
                checkValues();
              },
              color: Theme.of(context).colorScheme.secondary,
            )
          ],
        ),
      )),
    );
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        pickedImage = imageTemporary;
      });
    } on PlatformException {
      print("Failed to pick image");
    }
  }
}
