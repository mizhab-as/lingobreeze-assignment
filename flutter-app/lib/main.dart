import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/word.dart';
import 'providers/words_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WordsProvider()..fetchWords(),
      child: MaterialApp(
        title: 'LingoBreeze',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: const MyVocabularyScreen(),
      ),
    );
  }
}

class MyVocabularyScreen extends StatelessWidget {
  const MyVocabularyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vocabulary'),
        elevation: 1,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchWords(),
        child: Builder(builder: (context) {
          if (provider.state == WordsState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.state == WordsState.error) {
            return ListView(
              children: [
                const SizedBox(height: 80),
                Center(child: Text('Error: ${provider.errorMessage}')),
                const SizedBox(height: 8),
                Center(
                    child: ElevatedButton(
                  onPressed: () => provider.fetchWords(),
                  child: const Text('Retry'),
                )),
              ],
            );
          }

          if (provider.words.isEmpty) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 120),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.bookmark_border, size: 48, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(height: 12),
                        const Text("You haven't saved any words yet.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        const Text('Save words you want to review later. Tap the + button to add.', style: TextStyle(color: Colors.black54), textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: () => _showAddSheet(context), child: const Text('Add Your First Word'))
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: provider.words.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final Word w = provider.words[index];
              final date = (w.createdAt != null) ? (DateTime.tryParse(w.createdAt!)?.toLocal().toString().split(' ').first) : null;
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: Text(w.word, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                          if (date != null) Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12))
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Meaning: ${w.meaning}', style: const TextStyle(color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text('Translation: ${w.translation}', style: const TextStyle(color: Colors.black87)),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: AddWordForm(),
      ),
    );
  }
}

class AddWordForm extends StatefulWidget {
  const AddWordForm({super.key});

  @override
  State<AddWordForm> createState() => _AddWordFormState();
}

class _AddWordFormState extends State<AddWordForm> {
  final _formKey = GlobalKey<FormState>();
  final _wordCtrl = TextEditingController();
  final _meaningCtrl = TextEditingController();
  final _translationCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _wordCtrl.dispose();
    _meaningCtrl.dispose();
    _translationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordsProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Add Word', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _wordCtrl,
                decoration: const InputDecoration(labelText: 'Word'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _meaningCtrl,
                decoration: const InputDecoration(labelText: 'Meaning'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _translationCtrl,
                decoration: const InputDecoration(labelText: 'Translation'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              _saving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() => _saving = true);
                        try {
                          await provider.addWord(_wordCtrl.text.trim(), _meaningCtrl.text.trim(), _translationCtrl.text.trim());
                          if (mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Word saved')));
                          }
                        } catch (e) {
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
                      child: const Text('Save')),
            ]),
          )
        ],
      ),
    );
  }
}
