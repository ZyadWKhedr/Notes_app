final String tableNotes = 'notes';

class NoteFields {
  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String createdTime = 'createdTime';
}

class Note {
  final int? id; // Nullable since it's auto-incremented by the database
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  Note({
    this.id, // Make id nullable
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  // Convert a Note object to a Map
  Map<String, dynamic> toMap() {
    return {
      NoteFields.id: id, // Allow id to be null for new notes
      NoteFields.isImportant: isImportant ? 1 : 0,
      NoteFields.number: number,
      NoteFields.title: title,
      NoteFields.description: description,
      NoteFields.createdTime: createdTime.toIso8601String(), // Save as string
    };
  }

  Note copyWith({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) {
    return Note(
      id: id ?? this.id,
      isImportant: isImportant ?? this.isImportant,
      number: number ?? this.number,
      title: title ?? this.title,
      description: description ?? this.description,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  // Create a Note object from a Map (useful for retrieving from the database)
  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map[NoteFields.id] as int?, // Handle null safety
      isImportant: map[NoteFields.isImportant] == 1,
      number: map[NoteFields.number] as int,
      title: map[NoteFields.title] as String,
      description: map[NoteFields.description] as String,
      createdTime: DateTime.parse(map[NoteFields.createdTime] as String),
    );
  }
}
