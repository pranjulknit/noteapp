import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/cubit/auth%20/cubit/auth_cubit.dart';
import 'package:noteapp/cubit/note/cubit/note_cubit.dart';
import 'package:noteapp/router/page_constant.dart';

import '../models/note_model.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState

    context.read<NoteCubit>().getMyNotes(NoteModel(creatorId: widget.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, PageConst.addNotePage,
                arguments: widget.uid);
          }),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  print("homepage uid ${widget.uid}");
                  Navigator.pushNamed(context, PageConst.profilePage,
                      arguments: widget.uid);
                },
                child: const Icon(Icons.person_outline)),
            const SizedBox(
              width: 10,
            ),
            const Text("My Notes"),
          ],
        ),
        actions: [
          InkWell(
              onTap: () {
                context
                    .read<NoteCubit>()
                    .getMyNotes(NoteModel(creatorId: widget.uid));
              },
              child: const Icon(Icons.refresh)),
          const SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () {
                context.read<AuthCubit>().loggedOut();
              },
              child: const Icon(Icons.logout)),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, noteState) {
          if (noteState is NoteLoaded) {
            final notes = noteState.notes;
            notes.sort((a, b) => DateTime.fromMillisecondsSinceEpoch(
                    b.createAt!.toInt())
                .compareTo(
                    DateTime.fromMillisecondsSinceEpoch(a.createAt!.toInt())));
            return notes.isEmpty
                ? _addNoteMessageWidget(context)
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, PageConst.updateNotePage,
                                arguments: note);
                          },
                          title: Text("${note.title}"),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${note.description}"),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(DateFormat("dd MMMM yyy hh:mm a").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        note.createAt!.toInt()))),
                              ]),
                          trailing: InkWell(
                              onTap: () {
                                context
                                    .read<NoteCubit>()
                                    .deleteNote(NoteModel(noteId: note.noteId))
                                    .then((value) {
                                  context.read<NoteCubit>().getMyNotes(
                                      NoteModel(creatorId: widget.uid));
                                });
                              },
                              child: Icon(Icons.delete_outline)),
                        ),
                      );
                    },
                  );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  _addNoteMessageWidget(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "Add Notes",
          style: TextStyle(
              fontSize: 30,
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(.5)),
        )
      ]),
    );
  }
}
