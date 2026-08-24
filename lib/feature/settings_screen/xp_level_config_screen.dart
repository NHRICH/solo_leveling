import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solo_leveling/core/theme/app_themes.dart';
import 'package:solo_leveling/view_model/level_config_view_model.dart';

class XpLevelConfigScreen extends ConsumerWidget {
  const XpLevelConfigScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final configAsync = ref.watch(levelConfigViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'XP PER LEVEL',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: SystemColors.accent,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: cs.primary,
            size: 20,
          ),
        ),
      ),
      body: configAsync.when(
        data: (configs) {
          if (configs.isEmpty) {
            return const Center(child: Text('No level configs found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: configs.length,
            itemBuilder: (context, index) {
              final config = configs[index];
              return _buildLevelTile(
                context,
                ref,
                config.level,
                config.xpRequired,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildLevelTile(
    BuildContext context,
    WidgetRef ref,
    int level,
    int xpRequired,
  ) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: SystemColors.surfaceElevated.withAlpha(180),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: SystemColors.accent.withAlpha(40),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showEditDialog(context, ref, level, xpRequired),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        SystemColors.accent.withAlpha(40),
                        SystemColors.shadowViolet.withAlpha(40),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '$level',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: SystemColors.accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level $level',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${formatXp(xpRequired)} XP required to reach this level',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit_rounded,
                  color: SystemColors.accent.withAlpha(150),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    int level,
    int currentXp,
  ) {
    final controller = TextEditingController(text: '$currentXp');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SystemColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: SystemColors.accent.withAlpha(80),
            width: 1,
          ),
        ),
        title: Text(
          'Level $level',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: SystemColors.accent,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set XP required to reach Level $level',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(color: SystemColors.accent),
              decoration: InputDecoration(
                labelText: 'XP Required',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: SystemColors.accent),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: SystemColors.accent,
            ),
            onPressed: () {
              final newXp = int.tryParse(controller.text);
              if (newXp != null && newXp >= 0) {
                ref.read(levelConfigViewModelProvider.notifier).updateLevel(
                  level,
                  newXp,
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  static String formatXp(int xp) {
    if (xp >= 1000000) {
      return '${(xp / 1000000).toStringAsFixed(1)}M';
    } else if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(1)}K';
    }
    return '$xp';
  }
}