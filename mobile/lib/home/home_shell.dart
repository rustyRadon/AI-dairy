import "package:flutter/material.dart";

import "business_dna_screen.dart";
import "clarity_timeline_screen.dart";
import "presence_screen.dart";
import "settings_screen.dart";
import "weekly_mirror_screen.dart";

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.userName});
  final String userName;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _tab = 0;
  bool _openDnaAtKnowledgeBubbles = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pages = <Widget>[
      PresenceScreen(userName: widget.userName),
      ClarityTimelineScreen(userName: widget.userName),
      BusinessDnaScreen(
        userName: widget.userName,
        scrollKnowledgeOnOpen: _openDnaAtKnowledgeBubbles,
        onKnowledgeScrollConsumed: () {
          if (_openDnaAtKnowledgeBubbles) {
            setState(() => _openDnaAtKnowledgeBubbles = false);
          }
        },
      ),
      WeeklyMirrorScreen(userName: widget.userName),
      SettingsScreen(
        userName: widget.userName,
        onOpenKnowledgeBubbles: () => setState(() {
          _tab = 2;
          _openDnaAtKnowledgeBubbles = true;
        }),
      ),
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: KeyedSubtree(
            key: ValueKey(_tab),
            child: pages[_tab],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: cs.surface,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: NavigationBar(
          backgroundColor: cs.surface,
          indicatorColor: cs.onSurface.withValues(alpha: 0.08),
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.blur_on_outlined),
              selectedIcon: Icon(Icons.blur_on),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.timeline_outlined),
              selectedIcon: Icon(Icons.timeline),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: "",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}

