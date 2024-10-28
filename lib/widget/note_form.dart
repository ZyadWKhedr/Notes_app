import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_sqll/view_model/theme_provider.dart';

class NoteFormWidget extends StatefulWidget {
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  _NoteFormWidgetState createState() => _NoteFormWidgetState();
}

class _NoteFormWidgetState extends State<NoteFormWidget> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _showExplanation(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'Switch: Mark as Important indicates the significance of the note. \n'
        'Slider: Rate the note on a scale of 0 to 5.',
      ),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.blue,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Switch(
                        value: widget.isImportant,
                        onChanged: widget.onChangedImportant,
                        activeColor: isDarkMode ? Colors.amber : Colors.blue,
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        color: isDarkMode ? Colors.white70 : Colors.black,
                        onPressed: () => _showExplanation(context),
                      ),
                    ],
                  ),
                ),
              
                Expanded(
                  child: Slider(
                    value: widget.number.toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    activeColor: isDarkMode ? Colors.amber : Colors.blue,
                    inactiveColor: Colors.grey,
                    onChanged: (number) =>
                        widget.onChangedNumber(number.toInt()),
                  ),
                ),
              ],
            ),
            buildTitle(isDarkMode),
            const SizedBox(height: 8),
            buildDescription(isDarkMode),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(bool isDarkMode) => TextFormField(
        controller: titleController,
        maxLines: 1,
        style: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle:
              TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: (title) {
          widget.onChangedTitle(title);
        },
      );

  Widget buildDescription(bool isDarkMode) => TextFormField(
        controller: descriptionController,
        maxLines: 5,
        style: TextStyle(
            color: isDarkMode ? Colors.white60 : Colors.black54, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle:
              TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey),
        ),
        validator: (description) => description != null && description.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: (description) {
          widget.onChangedDescription(description);
        },
      );
}
