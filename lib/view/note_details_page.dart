import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; 
import 'package:todo_sqll/core/database/notes_db.dart';
import 'package:todo_sqll/view/edit_note_page.dart';
import 'package:todo_sqll/view_model/theme_provider.dart';
import '../model/note.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.blue, 
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : Colors.black, 
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: const TextStyle(color: Colors.white38),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.description,
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54, 
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget editButton() => IconButton(
        icon: const Icon(Icons.edit_outlined),
        onPressed: () async {
          if (isLoading) return;

          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddEditNotePage(note: note),
          ));

          refreshNote();
        },
      );

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await NotesDatabase.instance.deleteNote(widget.noteId);
          Navigator.of(context).pop();
        },
      );
}
