import 'package:flutter/material.dart';
import 'package:todo_sqll/core/database/notes_db.dart';
import 'package:todo_sqll/model/note.dart';
import 'package:todo_sqll/view_model/theme_provider.dart';
import 'package:todo_sqll/widget/note_form.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant,
            number: number,
            title: title,
            description: description,
            onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor:
              ThemeProvider().isDarkMode ? Colors.white : Colors.black,
          backgroundColor: isFormValid ? null : Colors.white,
        ),
        onPressed: isFormValid ? addOrUpdateNote : null,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      try {
        if (isUpdating) {
          await updateNote();
        } else {
          await addNote();
        }
        Navigator.of(context).pop();
      } catch (e) {
      
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving note: $e')),
        );
      }
    }
  }

  Future<void> addNote() async {
   
    final newNote = Note(
      id: null,
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.createNote(newNote);
  }

  Future<void> updateNote() async {
   
    final updatedNote = widget.note!.copyWith(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );
    await NotesDatabase.instance.updateNote(updatedNote);
  }
}
