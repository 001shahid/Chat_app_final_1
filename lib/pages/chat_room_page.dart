import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/modals/ChatRoomModal.dart';
import 'package:flutter_application_1/modals/Messagemodel.dart';
import 'package:flutter_application_1/modals/userModals.dart';
import 'package:flutter_application_1/pages/user_profile.dart';
import 'package:intl/intl.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModal targetUser;
  final ChatRoomModel chatroom;
  final UserModal userModal;
  final User firebaseUser;
  ChatRoomModel? selectedChatRoom;
  final List<String>? blockedUsers;

  ChatRoomPage(
      {Key? key,
      required this.targetUser,
      required this.chatroom,
      required this.userModal,
      required this.firebaseUser,
      this.selectedChatRoom,
      this.blockedUsers})
      : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();
  bool isUserOnline = false;
  bool isUserBlocked = false;
  MessageModel?
      selectedMessage; // Store the selected message for copying or replying

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();
    // bool isBlocked = await isUserBlocked;

    // if (isBlocked) {
    //   // Display an error message or take appropriate action
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text("Blocked"),
    //         content: Text(
    //             "You cannot send messages to this user as you have blocked them."),
    //         actions: [
    //           ElevatedButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: Text("OK"),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
    // Check if both users have blockedId set to false

    if (msg != "") {
      // Message send

      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.targetUser.uid,
        createdon: DateTime.now(),
        text: msg,
        seen: false,
        isStarred: false,
      );
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());
      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toMap());

      log("send message!");
    }
  }

  Future<void> deleteChat() async {
    // Delete all messages in the chat room
    final messagesCollection = FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatroom.chatroomid)
        .collection("messages");

    final messagesSnapshot = await messagesCollection.get();
    for (final doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Update the lastMessage field of the chatroom to indicate no messages.
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(widget.chatroom.chatroomid)
        .set({"lastmessage": ""}, SetOptions(merge: true));

    // Optionally, delete the chat room itself
    // await FirebaseFirestore.instance
    //     .collection("chatrooms")
    //     .doc(widget.chatroom.chatroomid)
    //     .delete();

    // Optionally, reset the selected chat room
    setState(() {
      widget.selectedChatRoom = null;
    });
  }

  void copyMessage(MessageModel message) {
    // Copy the message text to the clipboard
    final textToCopy =
        message.text ?? ''; // Provide an empty string as a default value
    Clipboard.setData(ClipboardData(text: textToCopy));

    // Show a notification or confirmation to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Message copied to clipboard'),
      ),
    );
  }

  void forwardMessage(MessageModel message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Forward Message'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Select Recipient'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final selectedRecipient = await selectRecipient(context);
                  if (selectedRecipient != null) {
                    sendForwardedMessage(message, selectedRecipient);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<UserModal?> selectRecipient(BuildContext context) async {
    try {
      // final QuerySnapshot chatListSnapshot = await FirebaseFirestore.instance.collection("")
      // .collection("chatroom")
      // .where("participants", arrayContains: widget.userModal.uid)
      // .get();
      final QuerySnapshot chatListSnapshot = await FirebaseFirestore.instance
          .collection("chatrooms")
          .where("participants.${widget.userModal.uid}", isEqualTo: true)
          .get();

      if (chatListSnapshot.docs.isEmpty) {
        print("No chat data found.");
        return null;
      }

      final List<UserModal> chatList = chatListSnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModal(
          uid: data['uid'],
          fullname: data['fullname'],
          profilepic: data['profilepic'],
          blockedId: false, // Add other properties as needed.
        );
      }).toList();

      final selectedUser = await showDialog<UserModal>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Recipient'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final user = chatList[index];
                  // UserModal targetUser = user;

                  //var targetUser;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilepic.toString()),
                    ),
                    title: Text(widget.userModal.fullname.toString()),
                    onTap: () {
                      Navigator.of(context)
                          .pop(user); // Return the selected user
                    },
                  );
                },
              ),
            ),
          );
        },
      );

      return selectedUser;
    } catch (e) {
      print("Error fetching chat list: $e");
      return null; // Handle the error gracefully in your application.
    }
  }

  void sendForwardedMessage(MessageModel message, UserModal recipient) async {
    try {
      // Create a new chat room if it doesn't exist between the sender and recipient.
      final chatroomCollection =
          FirebaseFirestore.instance.collection("chatrooms");
      final chatroomQuery = await chatroomCollection.where("users",
          arrayContainsAny: [widget.userModal.uid, recipient.uid]).get();

      String chatroomId;

      if (chatroomQuery.docs.isNotEmpty) {
        // Chat room already exists
        chatroomId = chatroomQuery.docs[0].id;
      } else {
        // Create a new chat room
        final newChatroom = ChatRoomModel(
          chatroomid: uuid.v1(),
          users: [widget.userModal.uid, recipient.uid],
          lastMessage: message.text, participants: {},
          // You may need to set other properties of the chat room here.
        );

        await chatroomCollection
            .doc(newChatroom.chatroomid)
            .set(newChatroom.toMap());
        chatroomId = newChatroom.chatroomid;
      }

      // Add the forwarded message to the chat room
      final forwardedMessage = MessageModel(
        messageid: message.messageid,
        sender: message.sender,
        createdon: DateTime.now(),
        text: message.text,
        seen: false,
        isStarred: false,
      );

      await chatroomCollection
          .doc(chatroomId)
          .collection("messages")
          .doc(forwardedMessage.messageid)
          .set(forwardedMessage.toMap());

      // Optionally, update the lastMessage field of the chat room.
      await chatroomCollection
          .doc(chatroomId)
          .set({"lastmessage": forwardedMessage.text}, SetOptions(merge: true));

      print("Forwarded message sent!");
    } catch (e) {
      print("Error sending forwarded message: $e");
    }
  }

  void replyToMessage(MessageModel message) {
    // Set the selected message for replying
    setState(() {
      selectedMessage = message;
    });

    // Update the message input field with a prefix for the reply
    messageController.text = 'Replying to: ${message.text}\n';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 95, 54),
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => User_Profile(
                  userModal: widget.userModal,
                  targetUser: widget.targetUser,
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage:
                    NetworkImage(widget.targetUser.profilepic.toString()),
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(widget.targetUser.fullname.toString()),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          deleteChat();
                        },
                        child: Text(
                          'Clear Chat',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),

      // appBar: AppBar(

      //   actions: [
      //     InkWell(
      //       onTap: () async {
      //         await blockUser(widget.targetUser);
      //       },
      //       child: Icon(Icons.lock),
      //     ),
      //     InkWell(
      //       onTap: () async {
      //         await unblockUser(widget.targetUser);
      //       },
      //       child: Icon(Icons.face_unlock_rounded),
      //     ),
      //     SizedBox(
      //       width: 20,
      //     ),
      //     InkWell(
      //       onTap: () async {
      //         await deleteChat();
      //         Navigator.of(context).pop();
      //       },
      //       child: Icon(Icons.delete),
      //     )
      //   ],
      //   child: Row(
      //     children: [
      //       CircleAvatar(
      //         backgroundColor: Colors.grey,
      //         backgroundImage:
      //             NetworkImage(widget.targetUser.profilepic.toString()),
      //       ),
      //       SizedBox(
      //         width: 10,
      //       ),
      //       Text(widget.targetUser.fullname.toString()),
      //     ],

      //   ),

      // ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  "https://wallpapercave.com/wp/wp10254485.jpg",
                ),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            // This is where the chat will go
            Expanded(
              child: Container(
                // color: Colors.blue
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatroom.chatroomid)
                      .collection("messages")
                      .orderBy("createdon", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                          //shrinkWrap: true,
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>,
                            );
                            // ...

                            Color doubleTickColor;

                            if (currentMessage.seen!) {
                              // Message is seen, color is blue
                              doubleTickColor = Colors.blue;
                            } else {
                              // Message is not seen, color is grey
                              doubleTickColor = Colors.grey;
                            }
                            return Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                              onDismissed: (direction) async {
                                if (direction == DismissDirection.startToEnd &&
                                    currentMessage.sender !=
                                        widget.userModal.uid) {
                                  DocumentReference chatRoomRef =
                                      FirebaseFirestore.instance
                                          .collection("chatrooms")
                                          .doc(widget.chatroom.chatroomid);

                                  // Delete a message
                                  await FirebaseFirestore.instance
                                      .collection("chatrooms")
                                      .doc(widget.chatroom.chatroomid)
                                      .collection("messages")
                                      .doc(currentMessage.messageid)
                                      .delete();

                                  QuerySnapshot messagesSnapshot =
                                      await chatRoomRef
                                          .collection("messages")
                                          .orderBy("createdon",
                                              descending: true)
                                          .get();

                                  if (messagesSnapshot.docs.isNotEmpty) {
                                    String latestMessage =
                                        messagesSnapshot.docs.first["text"];

                                    await FirebaseFirestore.instance
                                        .collection("chatrooms")
                                        .doc(widget.chatroom.chatroomid)
                                        .set(
                                      {"lastmessage": latestMessage},
                                      SetOptions(merge: true),
                                    );
                                  } else {
                                    await chatRoomRef.update({
                                      "lastmessage": "",
                                    });
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Message deleted'),
                                    ),
                                  );
                                }
                                // ...
                              },
                              child: Row(
                                mainAxisAlignment: (currentMessage.sender ==
                                        widget.userModal.uid)
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onLongPress: () {
                                      // Show options for copying, forwarding, and replying to the message
                                      showOptionsDialog(currentMessage);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 2),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: (currentMessage.sender ==
                                                widget.userModal.uid)
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentMessage.text.toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                DateFormat('hh:mm a').format(
                                                    currentMessage.createdon),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              // Icon(
                                              //   Icons.done_all,
                                              //   color: doubleTickColor,
                                              //   size: 16,
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              "An error occurred. Please check your internet connection."),
                        );
                      } else {
                        return Center(
                          child: Text("Say hi to your new friend!"),
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
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(50)),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Enter Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.secondary,
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

  void showOptionsDialog(MessageModel message) {
    // Display a dialog with options for copying, forwarding, and replying to the message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Message Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.copy),
                title: Text('Copy Message'),
                onTap: () {
                  Navigator.of(context).pop();
                  copyMessage(message);
                },
              ),
              ListTile(
                leading: Icon(Icons.forward),
                title: Text('Forward Message'),
                onTap: () {
                  Navigator.of(context).pop();
                  forwardMessage(message);
                },
              ),
              ListTile(
                leading: Icon(Icons.reply),
                title: Text('Reply to Message'),
                onTap: () {
                  Navigator.of(context).pop();
                  replyToMessage(message);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> blockUser(UserModal userToBlock) async {
    try {
      final userReference = FirebaseFirestore.instance.collection('users').doc(
          userToBlock
              .uid); // Replace 'users' with your Firestore collection name

      await userReference.update({
        'blockedId': true, // Set blockedId to true to block the user
      });

      // Optionally, you can update the userToBlock object locally if needed
      userToBlock.blockedId = true;

      print('User ${userToBlock.uid} is blocked.');
    } catch (e) {
      print('Error blocking user: $e');
    }
  }

  Future<void> unblockUser(UserModal userToUnblock) async {
    try {
      final userReference =
          FirebaseFirestore.instance.collection('users').doc(userToUnblock.uid);

      await userReference.update({
        'blockedId': false,
      });

      // Update the state to reflect that the user is unblocked
      setState(() {
        isUserBlocked = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ${userToUnblock.uid} is unblocked.'),
        ),
      );
    } catch (e) {
      print('Error unblocking user: $e');
    }
  }
}
