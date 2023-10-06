// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/modals/ChatRoomModal.dart';
// import 'package:flutter_application_1/modals/firebasehelper.dart';
// import 'package:flutter_application_1/modals/userModals.dart';
// import 'package:flutter_application_1/pages/ChatRoomPage.dart';
// import 'package:flutter_application_1/pages/SearchPage.dart';
// import 'package:flutter_application_1/pages/login.dart';

// class HomePage extends StatefulWidget {
//   final UserModal userModal;
//   final User firebaseUser;

//   const HomePage(
//       {super.key, required this.userModal, required this.firebaseUser});
//   //const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Chat App"),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.popUntil(context, (route) => route.isFirst);
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) {
//                   return LoginPage();
//                 }),
//               );
//             },
//             icon: Icon(Icons.exit_to_app),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Container(
//           child: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("chatrooms")
//                 .where("participants.${widget.userModal.uid}", isEqualTo: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.active) {
//                 if (snapshot.hasData) {
//                   QuerySnapshot chatRoomSnapshot =
//                       snapshot.data as QuerySnapshot;

//                   return ListView.builder(
//                     itemCount: chatRoomSnapshot.docs.length,
//                     itemBuilder: (context, index) {
//                       ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
//                           chatRoomSnapshot.docs[index].data()
//                               as Map<String, dynamic>);

//                       Map<String, dynamic> participants =
//                           chatRoomModel.participants!;

//                       List<String> participantKeys = participants.keys.toList();
//                       participantKeys.remove(widget.userModal.uid);
//                       //debugPrint(participantKeys.toString());

//                       return FutureBuilder(
//                         future:
//                             FirebaseHelper.getUserModalById(participantKeys[0]),
//                         builder: (context, userData) {
//                           if (userData.connectionState ==
//                               ConnectionState.done) {
//                             if (userData.data != null) {
//                               UserModal targetUser = userData.data as UserModal;
//                               //debugPrint(targetUser.uid);

//                               return ListTile(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) {
//                                       return ChatRoomPage(
//                                         chatroom: chatRoomModel,
//                                         firebaseUser: widget.firebaseUser,
//                                         userModal: widget.userModal,
//                                         targetUser: targetUser,
//                                       );
//                                     }),
//                                   );
//                                   Dismissible(
//                                     key: UniqueKey(),
//                                     background: Container(
//                                       color: Colors.red,
//                                       child: Align(
//                                         child: Icon(
//                                           Icons.delete,
//                                           color: Colors.white,
//                                         ),
//                                         alignment: Alignment.centerLeft,
//                                       ),
//                                     ),
//                                     onDismissed: (direction) async {
//                                   if (direction ==
//                                           DismissDirection.startToEnd){
//                                          await FirebaseFirestore.instance
//                                         .collection("chatrooms")
//                                         .doc(widget.chatroom.chatroomid)
//                                           .delete();

//                                           }
//                                     }
//                                   );
//                                 },
//                                 leading: InkWell(
//                                   onTap: () {
//                                     showDialog(
//                                         context: context,
//                                         builder: (BuildContext context) {
//                                           return Center(
//                                             child: Container(
//                                               height: 300,
//                                               width: 300,
//                                               decoration: BoxDecoration(
//                                                 shape: BoxShape.circle,
//                                                 image: DecorationImage(
//                                                   fit: BoxFit.cover,
//                                                   image: NetworkImage(targetUser
//                                                       .profilepic
//                                                       .toString()),
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         });
//                                   },
//                                   child: CircleAvatar(
//                                     backgroundImage: NetworkImage(
//                                         targetUser.profilepic.toString()),
//                                   ),
//                                 ),
//                                 // leading: CircleAvatar(
//                                 //   backgroundImage: NetworkImage(
//                                 //       targetUser.profilepic.toString()),
//                                 // ),
//                                 title: Text(targetUser.fullname.toString()),
//                                 subtitle: (chatRoomModel.lastMessage
//                                             .toString() !=
//                                         "")
//                                     ? Text(chatRoomModel.lastMessage.toString())
//                                     : Text(
//                                         "Say hi to your new friend!",
//                                         style: TextStyle(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .secondary,
//                                         ),
//                                       ),
//                               );
//                             } else {
//                               return Container();
//                             }
//                           } else {
//                             return Container();
//                           }
//                         },
//                       );
//                     },
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(snapshot.error.toString()),
//                   );
//                 } else {
//                   return Center(
//                     child: Text("No Chats"),
//                   );
//                 }
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return SearchPage(
//                 userModal: widget.userModal, firebaseUser: widget.firebaseUser);
//           }));
//         },
//         child: Icon(Icons.search),
//       ),
//     );
//   }
// }
// import 'dart:html';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/modals/ChatRoomModal.dart';
// import 'package:flutter_application_1/modals/firebasehelper.dart';
// import 'package:flutter_application_1/modals/userModals.dart';
// import 'package:flutter_application_1/pages/ChatRoomPage.dart';
// import 'package:flutter_application_1/pages/SearchPage.dart';
// import 'package:flutter_application_1/pages/login.dart';

// class HomePage extends StatefulWidget {
//   final UserModal userModal;
//   final User firebaseUser;
//   final ChatRoomModel ?chatroom;

//   const HomePage({
//     super.key,
//     required this.userModal,
//     required this.firebaseUser, this.chatroom,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Chat App"),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.popUntil(context, (route) => route.isFirst);
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) {
//                   return LoginPage();
//                 }),
//               );
//             },
//             icon: Icon(Icons.exit_to_app),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Container(
//           child: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection("chatrooms")
//                 .where("participants.${widget.userModal.uid}", isEqualTo: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.active) {
//                 if (snapshot.hasData) {
//                   QuerySnapshot chatRoomSnapshot =
//                       snapshot.data as QuerySnapshot;

//                   return ListView.builder(
//                     itemCount: chatRoomSnapshot.docs.length,
//                     itemBuilder: (context, index) {
//                       ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
//                           chatRoomSnapshot.docs[index].data()
//                               as Map<String, dynamic>);

//                       Map<String, dynamic> participants =
//                           chatRoomModel.participants!;

//                       List<String> participantKeys = participants.keys.toList();
//                       participantKeys.remove(widget.userModal.uid);
//                       //debugPrint(participantKeys.toString());

//                       return Dismissible(
//                         key: UniqueKey(),
//                         background: Container(
//                           color: Colors.red,
//                           child: Align(
//                             child: Icon(
//                               Icons.delete,
//                               color: Colors.white,
//                             ),
//                             alignment: Alignment.centerLeft,
//                           ),
//                         ),
//                         onDismissed: (direction) async {
//                           if (direction == DismissDirection.startToEnd) {
//                             await FirebaseFirestore.instance
//                                 .collection("chatrooms")
//                                 .doc(widget.chatroom?.chatroomid)
//                                 .collection("messages")
//                                 .doc()
//                                 .get()
//                                 .then((querySnapshot) {
//                               querySnapshot.docs.forEach((doc) {
//                                 doc.reference.delete();
//                               });
//                             });
//                           }
//                         },
//                         child: FutureBuilder(
//                           future: FirebaseHelper.getUserModalById(
//                               participantKeys[0]),
//                           builder: (context, userData) {
//                             if (userData.connectionState ==
//                                 ConnectionState.done) {
//                               if (userData.data != null) {
//                                 UserModal targetUser =
//                                     userData.data as UserModal;
//                                 //debugPrint(targetUser.uid);

//                                 return ListTile(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(builder: (context) {
//                                         return ChatRoomPage(
//                                           chatroom: chatRoomModel,
//                                           firebaseUser: widget.firebaseUser,
//                                           userModal: widget.userModal,
//                                           targetUser: targetUser,
//                                         );
//                                       }),
//                                     );
//                                   },
//                                   leading: InkWell(
//                                     onTap: () {
//                                       showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return Center(
//                                               child: Container(
//                                                 height: 300,
//                                                 width: 300,
//                                                 decoration: BoxDecoration(
//                                                   shape: BoxShape.circle,
//                                                   image: DecorationImage(
//                                                     fit: BoxFit.cover,
//                                                     image: NetworkImage(
//                                                         targetUser.profilepic
//                                                             .toString()),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           });
//                                     },
//                                     child: CircleAvatar(
//                                       backgroundImage: NetworkImage(
//                                           targetUser.profilepic.toString()),
//                                     ),
//                                   ),
//                                   title: Text(targetUser.fullname.toString()),
//                                   subtitle: (chatRoomModel.lastMessage
//                                               .toString() !=
//                                           "")
//                                       ? Text(
//                                           chatRoomModel.lastMessage.toString())
//                                       : Text(
//                                           "Say hi to your new friend!",
//                                           style: TextStyle(
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .secondary,
//                                           ),
//                                         ),
//                                 );
//                               } else {
//                                 return Container();
//                               }
//                             } else {
//                               return Container();
//                             }
//                           },
//                         ),
//                       );
//                     },
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text(snapshot.error.toString()),
//                   );
//                 } else {
//                   return Center(
//                     child: Text("No Chats"),
//                   );
//                 }
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) {
//             return SearchPage(
//                 userModal: widget.userModal, firebaseUser: widget.firebaseUser);
//           }));
//         },
//         child: Icon(Icons.search),
//       ),
//     );
//   }
// }
// Future<void> deleteMessages() async {
//   final messagesCollection = FirebaseFirestore.instance
//       .collection("chatrooms")
//       .doc(chatRoomModel.chatroomid)
//       .collection("messages");

//   final querySnapshot = await messagesCollection.get();

//   for (final doc in querySnapshot.docs) {
//     await doc.reference.delete();
//   }

//   // Optionally, update the lastMessage field of the chatroom to indicate no messages.
//   chatRoomModel.lastMessage = "";
//   await FirebaseFirestore.instance
//       .collection("chatrooms")
//       .doc(chatRoomModel.chatroomid)
//       .set(chatRoomModel.toMap());
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/modals/ChatRoomModal.dart';
import 'package:flutter_application_1/modals/firebasehelper.dart';
import 'package:flutter_application_1/modals/userModals.dart';
import 'package:flutter_application_1/pages/chat_room_page.dart';
import 'package:flutter_application_1/pages/search_page.dart';
import 'package:flutter_application_1/pages/Login_page.dart';
import 'package:flutter_application_1/pages/owner_profille.dart';

class HomePage extends StatefulWidget {
  final UserModal userModal;
  final User firebaseUser;
  // Add this field

  HomePage({
    super.key,
    required this.userModal,
    required this.firebaseUser,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 95, 54),
        centerTitle: true,
        title: Text("Chat App"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
            icon: Icon(Icons.exit_to_app),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    // title: Text("Setting"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add options or actions you want in the dialog
                        ListTile(
                          title: Text(
                            "New group",
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            // Handle Option 1
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ListTile(
                          title: Text(
                            "New broadcast",
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            // Handle Option 2
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Linked devices",
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            // Handle Option 2
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Starred messages",
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            // Handle Option 2
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Payment",
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            // Handle Option 2
                            Navigator.pop(context); // Close the dialog
                          },
                        ),
                        ListTile(
                          title: Text(
                            "Setting",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            // Handle Option 2
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OwnerProfile(
                                          userModal: widget.userModal,
                                          firebaseUser: widget.firebaseUser,
                                        ))); // Close the dialog
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.${widget.userModal.uid}", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot =
                      snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;

                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(widget.userModal.uid);
                      //debugPrint(participantKeys.toString());

                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.blue,
                          child: Align(
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            // setState(() {
                            //   widget.selectedChatRoom = chatRoomModel;
                            // });
                          }
                        },
                        child: FutureBuilder(
                          future: FirebaseHelper.getUserModalById(
                              participantKeys[0]),
                          builder: (context, userData) {
                            if (userData.connectionState ==
                                ConnectionState.done) {
                              if (userData.data != null) {
                                UserModal targetUser =
                                    userData.data as UserModal;
                                //debugPrint(targetUser.uid);

                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ChatRoomPage(
                                          chatroom: chatRoomModel,
                                          firebaseUser: widget.firebaseUser,
                                          userModal: widget.userModal,
                                          targetUser: targetUser,
                                        );
                                      }),
                                    );
                                  },
                                  leading: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Center(
                                              child: Container(
                                                height: 300,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        targetUser.profilepic
                                                            .toString()),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          targetUser.profilepic.toString()),
                                    ),
                                  ),
                                  title: Text(targetUser.fullname.toString()),
                                  subtitle: (chatRoomModel.lastMessage
                                              .toString() !=
                                          "")
                                      ? Text(
                                          chatRoomModel.lastMessage.toString())
                                      : Text(
                                          "Say hi to your new friend!",
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                );
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Center(
                    child: Text("No Chats"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 53, 95, 54),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPage(
                userModal: widget.userModal, firebaseUser: widget.firebaseUser);
          }));
        },
        child: Icon(
          Icons.search,
        ),
      ),
    );
  }
}
