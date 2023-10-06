import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/modals/ChatRoomModal.dart';
import 'package:flutter_application_1/modals/userModals.dart';
import 'package:flutter_application_1/pages/chat_room_page.dart';

class SearchPage extends StatefulWidget {
  final UserModal userModal;
  final User firebaseUser;

  const SearchPage(
      {super.key, required this.userModal, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModal targetUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModal.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.length > 0) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = existingChatroom;
    } else {
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModal.uid.toString(): true,
          targetUser.uid.toString(): true
        },
        messages: [],
        users: [],
      );
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());
      chatRoom = newChatroom;
      log("new chatroom created!");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 95, 54),
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(height: 20),
              CupertinoButton(
                onPressed: () {
                  setState(() {});
                },
                color: const Color.fromARGB(255, 53, 95, 54),
                child: Text("Search"),
              ),
              SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .orderBy("fullname")
                    .startAt([searchController.text]).endAt(
                        [searchController.text + '\uf8ff']).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      return Column(
                        children:
                            dataSnapshot.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> userMap =
                              document.data() as Map<String, dynamic>;
                          UserModal searchedUser = UserModal.fromMap(userMap);

                          // Check if the searched user is the same as the logged-in user
                          if (searchedUser.uid == widget.userModal.uid) {
                            return Container(); // Skip the logged-in user
                          }

                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: ListTile(
                              onTap: () async {
                                ChatRoomModel? chatRoomModel =
                                    await getChatroomModel(searchedUser);
                                if (chatRoomModel != null) {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ChatRoomPage(
                                        targetUser: searchedUser,
                                        userModal: widget.userModal,
                                        firebaseUser: widget.firebaseUser,
                                        chatroom: chatRoomModel,
                                        blockedUsers: [],
                                      );
                                    },
                                  ));
                                }
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(searchedUser.profilepic!),
                                backgroundColor: Colors.black,
                              ),
                              title: Text(searchedUser.fullname!),
                              subtitle: Text(searchedUser.email!),
                              //trailing: Icon(Icons.keyboard_arrow_right),
                            ),
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("An error occurred!");
                    } else {
                      return Text("No result found!");
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
