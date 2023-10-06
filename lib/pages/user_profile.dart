import 'dart:ffi';
//import 'package:chat_app1/modals/userModals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/modals/userModals.dart';

class User_Profile extends StatefulWidget {
  final UserModal userModal;
  final UserModal targetUser;
  const User_Profile(
      {super.key, required this.userModal, required this.targetUser});

  @override
  State<User_Profile> createState() => _User_ProfileState();
}

class _User_ProfileState extends State<User_Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 3, 79, 6),
        title: Text(
          widget.targetUser.fullname.toString(), style: TextStyle(fontSize: 30),
          //widget.targetUser.profilepic.toString(),
        ),
        //,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 249, 251, 249),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    widget.targetUser.profilepic.toString(),
                  ),
                  radius: 110,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.targetUser.fullname.toString(),
                  style: TextStyle(
                    fontSize: 40,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   //"+9193729991595"
                //   // widget.targetUser.fullname.toString()
                //   ,
                //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                // )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.phone,
                  size: 30,
                  color: Color.fromARGB(255, 10, 148, 12),
                ),
                Icon(
                  Icons.video_call,
                  size: 30,
                  color: Color.fromARGB(255, 10, 148, 12),
                ),
                Icon(
                  Icons.payment_sharp,
                  size: 30,
                  color: Color.fromARGB(255, 10, 148, 12),
                ),
                Icon(
                  Icons.search,
                  size: 30,
                  color: Color.fromARGB(255, 10, 148, 12),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Audio",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 14, 124, 16),
                  ),
                ),
                Text(
                  "Videos",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 14, 124, 16),
                    //color: Color.fromARGB(255, 10, 148, 12),
                  ),
                ),
                Text("Pay",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 14, 124, 16),
                      //Color.fromARGB(255, 10, 148, 12),
                    )),
                Text("Search",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 14, 124, 16),
                      // Color.fromARGB(255, 10, 148, 12),
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * .16,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Color.fromARGB(255, 249, 251, 249),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Icon(
                                Icons.block,
                                size: 25,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Block",
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.targetUser.fullname.toString(),
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              Icon(
                                Icons.cancel,
                                size: 30,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            )
            //Icon(Icons.block)
          ],
        ),
      ),
    );
  }
}
