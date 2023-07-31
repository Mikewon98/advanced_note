import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> deleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Delete",
    content: "Are you sure you want to Delete this note?",
    optionsBuilder: () => {
      'cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
