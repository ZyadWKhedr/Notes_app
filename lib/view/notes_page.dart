import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_sqll/core/database/notes_db.dart';
import 'package:todo_sqll/view/edit_note_page.dart';
import 'package:todo_sqll/view/note_details_page.dart';
import 'package:todo_sqll/view_model/theme_provider.dart';
import 'package:todo_sqll/widget/note_card.dart';
import '../model/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future<void> refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
         
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeColor: Colors.amber,
          ),
          const SizedBox(width: 12),
        ],
        backgroundColor: themeProvider.isDarkMode
            ? Colors.black
            : const Color.fromARGB(255, 3, 103, 185),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.asset(
                          'assets/Animation - 1729515597323.json'),
                      const SizedBox(height: 20),
                      Text(
                        'No Notes',
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                )
              : buildNotes(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeProvider.isDarkMode ? Colors.grey : Colors.black,
        child: Icon(
          Icons.add,
          color: themeProvider.isDarkMode ? Colors.black : Colors.white,
        ),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddEditNotePage()),
          );
          refreshNotes();
        },
      ),
    );
  }

  Widget buildNotes() => StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: List.generate(
          notes.length,
          (index) {
            final note = notes[index];
            return StaggeredGridTile.fit(
              crossAxisCellCount: 1,
              child: GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteDetailPage(noteId: note.id!),
                  ));
                  refreshNotes();
                },
                child: NoteCardWidget(note: note, index: index),
              ),
            );
          },
        ),
      );
}
