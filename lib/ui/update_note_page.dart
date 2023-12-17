import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/models/note_model.dart';
import 'package:noteapp/ui/widgets/custom_button.dart';
import 'package:noteapp/ui/widgets/custom_text_field.dart';

import '../cubit/note/cubit/note_cubit.dart';
import 'widgets/common/common.dart';

class UpdateNotePage extends StatefulWidget {
  final NoteModel note;

  const UpdateNotePage({super.key, required this.note});

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _titleController.value = TextEditingValue(text: widget.note.title!);
    _descriptionController.value =
        TextEditingValue(text: widget.note.description!);
    super.initState();
  }

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
          title: const Text("Update Note"),
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
            CustomButton(title: "Update Note", onTap: _updateNote),
          ],
        ),
      ),
    );
  }

  void _updateNote() {
    if (_titleController.text.isEmpty) {
      showSnackBarMessage("Enter Note Name", context);
      return;
    }

    if (_descriptionController.text.isEmpty) {
      showSnackBarMessage("Enter Description", context);
      return;
    }

    context.read<NoteCubit>().updateNote(NoteModel(
        title: _titleController.text,
        description: _descriptionController.text,
        noteId: widget.note.noteId,
        createAt: DateTime.now().millisecondsSinceEpoch));

    showSnackBarMessage("Note Updated Successfully", context);
  }
}
