import 'dart:io';

import 'package:finesse_nation/Finesse.dart';
import 'package:finesse_nation/Network.dart';
import 'package:finesse_nation/Styles.dart';
import 'package:finesse_nation/User.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Utility functions used by multiple files.

/// Updates vote info for [currentUser] and [fin].
void handleVote(int index, List<bool> isSelected, Finesse fin) {
  List<String> upvoted = User.currentUser.upvoted;
  List<String> downvoted = User.currentUser.downvoted;
  for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
    if (buttonIndex == index) {
      // button that was pressed
      if (index == 0) {
        // upvote
        if (isSelected[buttonIndex]) {
          upvoted.remove(fin.eventId);
          fin.downvote();
        } else {
          upvoted.add(fin.eventId);
          fin.upvote();
        }
      } else {
        // downvote
        if (isSelected[buttonIndex]) {
          downvoted.remove(fin.eventId);
          fin.upvote();
        } else {
          downvoted.add(fin.eventId);
          fin.downvote();
        }
      }
      isSelected[buttonIndex] = !isSelected[buttonIndex];
    } else {
      // button that wasn't pressed
      if (index == 0) {
        // upvote
        if (isSelected[buttonIndex]) {
          downvoted.remove(fin.eventId);
          fin.upvote();
        }
      } else {
        // downvote
        if (isSelected[buttonIndex]) {
          upvoted.remove(fin.eventId);
          fin.downvote();
        }
      }
      isSelected[buttonIndex] = false;
    }
  }
  setVotes();
  updateFinesse(fin);
}

/// Displays a dialog allowing the user to input an image.
Future<File> uploadImagePopup(BuildContext context) async {
  final picker = ImagePicker();
  File image;

  AlertDialog dialog = AlertDialog(
    backgroundColor: secondaryBackground,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    title: Text(
      'Add image',
      style: TextStyle(
        color: primaryHighlight,
      ),
    ),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.photo_camera,
            color: primaryHighlight,
            size: 50,
          ),
          onPressed: () async {
            PickedFile pickedFile =
            await picker.getImage(source: ImageSource.camera);
            if (pickedFile != null) {
              image = File(pickedFile.path);
              Navigator.of(context).pop();
            }
          },
        ),
        IconButton(
          icon: Icon(
            Icons.photo,
            color: primaryHighlight,
            size: 50,
          ),
          onPressed: () async {
            PickedFile pickedFile =
            await picker.getImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              image = File(pickedFile.path);
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        child: Text(
          'CANCEL',
          style: TextStyle(color: secondaryHighlight),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
  await showDialog(
    context: context,
    builder: (_) => dialog,
  );

  return image;
}
