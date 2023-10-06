// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/modals/ChatRoomModal.dart';
// import 'package:flutter_application_1/modals/firebasehelper.dart';
// import 'package:flutter_application_1/modals/userModals.dart';
// import 'package:flutter_application_1/pages/ChatRoomPage.dart';
// import 'package:flutter_application_1/pages/SearchPage.dart';

// // class Tabbar extends StatefulWidget {
// //   final UserModal userModal;
// //   final User firebaseUser;
// //   Tabbar({super.key, required this.userModal, required this.firebaseUser});

// //   @override
// //   State<Tabbar> createState() => _TabbarState();
// // }

// // class _TabbarState extends State<Tabbar> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //         length: 3,
// //         child: Scaffold(
// //           appBar: AppBar(
// //             bottom: TabBar(
// //               tabs: [
// //                 Tab(text: "chats"),
// //                 Tab(
// //                   text: "updates",
// //                 ),
// //                 Tab(text: "status")
// //               ],
// //             ),
// //             title: Text("ChatApp"),
// //             actions: [
// //               InkWell(
// //                   onTap: () {
// //                     Navigator.push(context,
// //                         MaterialPageRoute(builder: (context) {
// //                       return SearchPage(
// //                           userModal: widget.userModal,
// //                           firebaseUser: widget.firebaseUser);
// //                     }));
// //                   },
// //                   child: Icon(Icons.search)),
// //               SizedBox(
// //                 width: 40,
// //               )
// //             ],
// //           ),
// //           body: TabBarView(children: [
// //             Container(
// //               child: StreamBuilder(
// //                 stream: FirebaseFirestore.instance
// //                     .collection("chatrooms")
// //                     .where("participants.${widget.userModal.uid}",
// //                         isEqualTo: true)
// //                     .snapshots(),
// //                 builder: (context, snapshot) {
// //                   if (snapshot.connectionState == ConnectionState.active) {
// //                     if (snapshot.hasData) {
// //                       QuerySnapshot chatRoomSnapshot =
// //                           snapshot.data as QuerySnapshot;

// //                       return ListView.builder(
// //                         itemCount: chatRoomSnapshot.docs.length,
// //                         itemBuilder: (context, index) {
// //                           ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
// //                               chatRoomSnapshot.docs[index].data()
// //                                   as Map<String, dynamic>);

// //                           Map<String, dynamic> participants =
// //                               chatRoomModel.participants!;

// //                           List<String> participantKeys =
// //                               participants.keys.toList();
// //                           participantKeys.remove(widget.userModal.uid);
// //                           //debugPrint(participantKeys.toString());

// //                           return FutureBuilder(
// //                             future: FirebaseHelper.getUserModalById(
// //                                 participantKeys[0]),
// //                             builder: (context, userData) {
// //                               if (userData.connectionState ==
// //                                   ConnectionState.done) {
// //                                 if (userData.data != null) {
// //                                   UserModal targetUser =
// //                                       userData.data as UserModal;
// //                                   //debugPrint(targetUser.uid);

// //                                   return ListTile(
// //                                     onTap: () {
// //                                       Navigator.push(
// //                                         context,
// //                                         MaterialPageRoute(builder: (context) {
// //                                           return ChatRoomPage(
// //                                             chatroom: chatRoomModel,
// //                                             firebaseUser: widget.firebaseUser,
// //                                             userModal: widget.userModal,
// //                                             targetUser: targetUser,
// //                                           );
// //                                         }),
// //                                       );
// //                                     },
// //                                     leading: CircleAvatar(
// //                                       backgroundImage: NetworkImage(
// //                                           targetUser.profilepic.toString()),
// //                                     ),
// //                                     title: Text(targetUser.fullname.toString()),
// //                                     subtitle:
// //                                         (chatRoomModel.lastMessage.toString() !=
// //                                                 "")
// //                                             ? Text(chatRoomModel.lastMessage
// //                                                 .toString())
// //                                             : Text(
// //                                                 "Say hi to your new friend!",
// //                                                 style: TextStyle(
// //                                                   color: Theme.of(context)
// //                                                       .colorScheme
// //                                                       .secondary,
// //                                                 ),
// //                                               ),
// //                                   );
// //                                 } else {
// //                                   return Container();
// //                                 }
// //                               } else {
// //                                 return Container();
// //                               }
// //                             },
// //                           );
// //                         },
// //                       );
// //                     } else if (snapshot.hasError) {
// //                       return Center(
// //                         child: Text(snapshot.error.toString()),
// //                       );
// //                     } else {
// //                       return Center(
// //                         child: Text("No Chats"),
// //                       );
// //                     }
// //                   } else {
// //                     return Center(
// //                       child: CircularProgressIndicator(),
// //                     );
// //                   }
// //                 },
// //               ),
// //             ),
// //           ]),
// //         ));
// //   }
// // }

// class Tabbar extends StatefulWidget {
//   final UserModal userModal;
//   final User firebaseUser;

//   Tabbar({Key? key, required this.userModal, required this.firebaseUser})
//       : super(key: key);

//   @override
//   State<Tabbar> createState() => _TabbarState();
// }

// class _TabbarState extends State<Tabbar> {
//   Widget buildChatList() {
//     return Container(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("chatrooms")
//             .where("participants.${widget.userModal.uid}", isEqualTo: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.active) {
//             if (snapshot.hasData) {
//               QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

//               return ListView.builder(
//                 itemCount: chatRoomSnapshot.docs.length,
//                 itemBuilder: (context, index) {
//                   ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
//                       chatRoomSnapshot.docs[index].data()
//                           as Map<String, dynamic>);

//                   Map<String, dynamic> participants =
//                       chatRoomModel.participants!;

//                   List<String> participantKeys = participants.keys.toList();
//                   participantKeys.remove(widget.userModal.uid);

//                   return FutureBuilder(
//                     future: FirebaseHelper.getUserModalById(participantKeys[0]),
//                     builder: (context, userData) {
//                       if (userData.connectionState == ConnectionState.done) {
//                         if (userData.data != null) {
//                           UserModal targetUser = userData.data as UserModal;

//                           return ListTile(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) {
//                                   return ChatRoomPage(
//                                     chatroom: chatRoomModel,
//                                     firebaseUser: widget.firebaseUser,
//                                     userModal: widget.userModal,
//                                     targetUser: targetUser,

//                                   );
//                                 }),
//                               );
//                             },
//                             leading: CircleAvatar(
//                               backgroundImage: NetworkImage(
//                                   targetUser.profilepic.toString()),
//                             ),
//                             title: Text(targetUser.fullname.toString()),
//                             subtitle:
//                                 (chatRoomModel.lastMessage.toString() != "")
//                                     ? Text(chatRoomModel.lastMessage.toString())
//                                     : Text(
//                                         "Say hi to your new friend!",
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .secondary,
//                                         ),
//                                       ),
//                           );
//                         } else {
//                           return Container();
//                         }
//                       } else {
//                         return Container();
//                       }
//                     },
//                   );
//                 },
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text(snapshot.error.toString()),
//               );
//             } else {
//               return Center(
//                 child: Text("No Chats"),
//               );
//             }
//           } else {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           bottom: TabBar(
//             tabs: [
//               Tab(text: "chats"),
//               Tab(text: "updates"),
//               Tab(text: "status"),
//             ],
//           ),
//           title: Text("ChatApp"),
//           actions: [
//             InkWell(
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return SearchPage(
//                     userModal: widget.userModal,
//                     firebaseUser: widget.firebaseUser,
//                   );
//                 }));
//               },
//               child: Icon(Icons.search),
//             ),
//             SizedBox(
//               width: 40,
//             )
//           ],
//         ),
//         body: TabBarView(
//           children: [
//             buildChatList(),
//             Icon(Icons.abc),
//             Icon(Icons.abc) // Display the chat list in the "chats" tab
//             // Other tab views for "updates" and "status"
//           ],
//         ),
//       ),
//     );
//   }
// }
