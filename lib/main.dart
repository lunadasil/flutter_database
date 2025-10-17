import 'package:flutter/material.dart';
import 'database_helper.dart';

// Using a simple global for the demo (per assignment note).
final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init(); // initialize database before runApp
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // --- Button actions (exact behaviors from the handout) ---
  Future<void> _insert(BuildContext context) async {
    final row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23,
    };
    final id = await dbHelper.insert(row);
    _log(context, 'Inserted row id: $id');
  }

  Future<void> _query(BuildContext context) async {
    final allRows = await dbHelper.queryAllRows();
    if (allRows.isEmpty) {
      _log(context, 'No rows found.');
    } else {
      _log(context, 'All rows:\n${allRows.map((e) => e.toString()).join('\n')}');
    }
  }

  Future<void> _update(BuildContext context) async {
    final row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32,
    };
    final rowsAffected = await dbHelper.update(row);
    _log(context, 'Updated $rowsAffected row(s)');
  }

  Future<void> _delete(BuildContext context) async {
    // As in the assignment: use row count as "last id" assumption
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    _log(context, 'Deleted $rowsDeleted row(s): row $id');
  }

  // Tiny helper to surface results in the UI *and* console
  void _log(BuildContext context, String message) {
    // debug print (like the handout)
    // ignore: avoid_print
    print(message);

    // visible feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('sqflite')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Local SQLite Demo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => _insert(context),
                    child: const Text('insert'),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.tonal(
                    onPressed: () => _query(context),
                    child: const Text('query'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => _update(context),
                    child: const Text('update'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => _delete(context),
                    child: const Text('delete'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
