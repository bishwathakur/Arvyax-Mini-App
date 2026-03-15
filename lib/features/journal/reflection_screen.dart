import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'providers.dart';
import '../../data/models/reflection.dart';

class ReflectionScreen extends ConsumerStatefulWidget {
  const ReflectionScreen({super.key});

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedMood = 'Calm';
  final List<String> _moods = ['Calm', 'Grounded', 'Energized', 'Sleepy'];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We fetch the last session or use a default if it was cleared.
    // The player clears session on end, so we might need to get the title from the last before clear, or we keep it.
    // Given the assignment flow: ending session goes to reflection.
    // We can fetch the last active session from the repo directly or have passed it as state.
    // Actually, since session is cleared, let's just use string 'Recent Session' if no title is available.
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflection'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'What is gently present with you right now?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              TextField(
                controller: _textController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Type your reflection here...',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              const Text(
                'How are you feeling?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood;
                  return ChoiceChip(
                    label: Text(mood),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedMood = mood);
                      }
                    },
                    selectedColor: Theme.of(context).colorScheme.primary,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    labelStyle: TextStyle(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.onPrimary 
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveReflection(context, ref),
                  child: const Text('Save Reflection'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveReflection(BuildContext context, WidgetRef ref) {
    if (_textController.text.trim().isEmpty) return;

    final reflection = Reflection(
      id: const Uuid().v4(),
      dateTime: DateTime.now(),
      ambienceTitle: 'Completed Session', // Ideally passed from the ended session
      mood: _selectedMood,
      text: _textController.text.trim(),
    );

    ref.read(journalProvider.notifier).saveReflection(reflection);
    context.go('/');
  }
}
