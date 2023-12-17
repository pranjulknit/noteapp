import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/cubit/note/cubit/note_cubit.dart';
import 'package:noteapp/models/note_model.dart';
import 'package:noteapp/ui/widgets/common/common.dart';
import 'package:noteapp/ui/widgets/custom_button.dart';
import 'package:noteapp/ui/widgets/custom_text_field.dart';

class AddNotePage extends StatefulWidget {
  final String uid;

  const AddNotePage({super.key, required this.uid});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  _AddNotePageState();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add New Note"),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            CustomTextField(
              hint: "title",
              controller: _titleController,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLines: 10,
                controller: _descriptionController,
                decoration: const InputDecoration(
                    hintText: "Description", border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(title: "Add Note", onTap: _addNewNote),
          ],
        ),
      ),
    );
  }

  void _addNewNote() {
    if (_titleController.text.isEmpty) {
      showSnackBarMessage("Enter Note Name", context);
      return;
    }

    if (_descriptionController.text.isEmpty) {
      showSnackBarMessage("Enter Description", context);
      return;
    }

    context
        .read<NoteCubit>()
        .addNote(NoteModel(
          title: _titleController.text,
          description: _descriptionController.text,
          creatorId: widget.uid,
        ))
        .then((value) {
      _clear();
    });
  }

  void _clear() {
    _titleController.clear();
    _descriptionController.clear();
    showSnackBarMessage("New Note added successfully", context);
    setState(() {});
  }
}
