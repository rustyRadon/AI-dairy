import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:share_plus/share_plus.dart";

import "../shared/ui/glass_card.dart";
import "../shared/widgets/screen_frame.dart";

class ClarityTimelineScreen extends StatefulWidget {
  const ClarityTimelineScreen({super.key, required this.userName});
  final String userName;

  @override
  State<ClarityTimelineScreen> createState() => _ClarityTimelineScreenState();
}

class _ClarityTimelineScreenState extends State<ClarityTimelineScreen> {
  final _scroll = ScrollController();
  final _search = TextEditingController();
  bool _loadingMore = false;
  _TimelineFilter _filter = _TimelineFilter.all;
  String _query = "";

  final List<_TimelineItem> _items = [
    _TimelineItem(
      time: "Yesterday · 11:20 AM",
      headline: "Brand launch check-in",
      insight: "You asked for a calmer plan. We made the first step smaller.",
      preGame: "If it spikes: one slow breath → one sentence → begin.",
      isFuture: false,
      category: _TimelineCategory.business,
    ),
    _TimelineItem(
      time: "4:00 PM",
      headline: "Outreach, but gentle",
      insight: "Keep it specific. One message. One boundary. Then rest.",
      preGame: "You don’t need to impress. Be specific and kind.",
      isFuture: true,
      category: _TimelineCategory.business,
    ),
    _TimelineItem(
      time: "Tomorrow · 7:00 PM",
      headline: "Dinner plans",
      insight: "You said you want something quiet. Keep it simple.",
      preGame: "Start imperfect. Momentum comes after you begin.",
      isFuture: true,
      category: _TimelineCategory.life,
    ),
    _TimelineItem(
      time: "Tomorrow · 12:30 PM",
      headline: "Lunch with Sarah",
      insight: "If it’s unclear, we can tag it in one tap.",
      preGame: "Show up. Be present. Keep it light.",
      isFuture: true,
      category: _TimelineCategory.unknown,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_loadingMore) return;
    if (!_scroll.hasClients) return;
    final p = _scroll.position;
    if (p.maxScrollExtent <= 0) return;
    final ratio = p.pixels / p.maxScrollExtent;
    if (ratio > 0.82) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    _loadingMore = true;
    // Tiny delay so it feels like the timeline continues (UI-only).
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;

    final start = _items.length;
    final more = List<_TimelineItem>.generate(6, (i) {
      final idx = start + i;
      final isFuture = (idx % 3) != 0;
      final cat = switch (idx % 4) {
        0 => _TimelineCategory.business,
        1 => _TimelineCategory.life,
        2 => _TimelineCategory.unknown,
        _ => _TimelineCategory.business,
      };
      return _TimelineItem(
        time: isFuture
            ? "Next · ${9 + (idx % 4)}:${idx % 2 == 0 ? "00" : "30"}"
            : "Earlier",
        headline: isFuture ? "Commitment check-in" : "Quick reset",
        insight: isFuture
            ? "One clear action. One boundary. Then rest."
            : "We named the feeling and softened the noise.",
        preGame: isFuture
            ? "Keep it small: write → send → done."
            : "Breathe. Label it. Pick one next step.",
        isFuture: isFuture,
        category: cat,
      );
    });

    setState(() => _items.addAll(more));
    _loadingMore = false;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final counts = _Counts.from(_items);
    return ScreenFrame(
      title: "Clarity Timeline",
      subtitle: "See your days in order — what happened and what comes next.",
      trailing: const SizedBox(width: 48),
      child: Column(
        children: [
          const SizedBox(height: 6),
          _FilterPills(
            filter: _filter,
            counts: counts,
            onChanged: (f) => setState(() => _filter = f),
          ),
          const SizedBox(height: 10),
          _SearchPill(
            controller: _search,
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ReorderableListView.builder(
              scrollController: _scroll,
              padding: const EdgeInsets.only(bottom: 18),
              itemCount: _items.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _items.removeAt(oldIndex);
                  _items.insert(newIndex, item);
                });
              },
              itemBuilder: (context, i) {
                final item = _items[i];
                final category = item.category ?? _TimelineCategory.unknown;
                final dim =
                    _filter != _TimelineFilter.all && !_filter.matches(category);
                final desaturate = item.isFuture ? 1.0 : 0.78;
                final aura = _auraFor(category, cs);

                final q = _query;
                final matchesQuery = q.isEmpty ||
                    (item.headline ?? "").toLowerCase().contains(q) ||
                    (item.insight ?? "").toLowerCase().contains(q) ||
                    (item.time ?? "").toLowerCase().contains(q);
                if (!matchesQuery) {
                  // Keep list stable, but hide non-matching items softly.
                  return const SizedBox.shrink(key: ValueKey("__hidden__"));
                }

                final card = _TimelineCard(
                  item: item,
                  onFixCategory: category == _TimelineCategory.unknown
                      ? () => _fixCategory(item)
                      : null,
                  onShare: () => _shareItem(item),
                );

                // Micro polish: slight overlap so glass feels "stacked".
                final overlap = i == 0 ? 0.0 : -6.0;

                return KeyedSubtree(
                  key: ValueKey(item.id),
                  child: Transform.translate(
                    offset: Offset(0, overlap),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: i == 0 ? 10 : 0,
                        bottom: 14,
                      ),
                      child: Stack(
                        children: [
                          // Vertical guide line.
                          Positioned(
                            left: 14,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 2,
                              color: cs.onSurface.withValues(alpha: 0.10),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 6),
                              // Dot.
                              Container(
                                margin: const EdgeInsets.only(top: 26),
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: aura.core,
                                  boxShadow: [
                                    BoxShadow(
                                      color: aura.core.withValues(alpha: 0.18),
                                      blurRadius: 18,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: dim ? 0.10 : 1,
                                  child: IgnorePointer(
                                    ignoring: dim,
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.matrix(
                                        _saturationMatrix(desaturate),
                                      ),
                                      child: _AuraCard(
                                        aura: aura,
                                        child: card,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ReorderableDragStartListener(
                                index: i,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 22),
                                  child: Icon(
                                    Icons.drag_handle_rounded,
                                    color: cs.onSurface.withValues(alpha: 0.40),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fixCategory(_TimelineItem item) async {
    final cs = Theme.of(context).colorScheme;
    final picked = await showModalBottomSheet<_TimelineCategory>(
      context: context,
      backgroundColor: cs.surface,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Tag this as…",
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                    _TimelineCategory.business,
                  ),
                  child: const Text("Business"),
                ),
                const SizedBox(height: 10),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.tertiary,
                    foregroundColor: cs.onTertiary,
                  ),
                  onPressed: () => Navigator.of(context).pop(
                    _TimelineCategory.life,
                  ),
                  child: const Text("Life"),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || picked == null) return;
    setState(() {
      final idx = _items.indexWhere((x) => x.id == item.id);
      if (idx == -1) return;
      _items[idx] = _items[idx].copyWith(category: picked);
    });
  }

  Future<void> _shareItem(_TimelineItem item) async {
    final time = item.time ?? "";
    final headline = item.headline ?? "";
    final insight = item.insight ?? "";
    final text = [headline, if (time.isNotEmpty) time, if (insight.isNotEmpty) insight]
        .where((s) => s.trim().isNotEmpty)
        .join("\n");

    try {
      await Share.share(text);
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: text));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Copied to clipboard."),
          duration: const Duration(milliseconds: 900),
          behavior: SnackBarBehavior.floating,
          backgroundColor:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
          elevation: 0,
        ),
      );
    }
  }
}

List<double> _saturationMatrix(double s) {
  final inv = 1 - s;
  final r = 0.2126 * inv;
  final g = 0.7152 * inv;
  final b = 0.0722 * inv;
  return <double>[
    r + s, g, b, 0, 0,
    r, g + s, b, 0, 0,
    r, g, b + s, 0, 0,
    0, 0, 0, 1, 0,
  ];
}

class _TimelineCard extends StatefulWidget {
  const _TimelineCard({required this.item, this.onFixCategory, this.onShare});
  final _TimelineItem item;
  final VoidCallback? onFixCategory;
  final VoidCallback? onShare;

  @override
  State<_TimelineCard> createState() => _TimelineCardState();
}

class _TimelineCardState extends State<_TimelineCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final item = widget.item;
    final time = item.time ?? "";
    final headline = item.headline ?? "";
    final insight = item.insight ?? "";
    final preGame = item.preGame ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                time,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
            ),
            if (widget.onShare != null)
              IconButton(
                tooltip: "Share",
                icon: Icon(
                  Icons.ios_share_rounded,
                  size: 18,
                  color: cs.onSurface.withValues(alpha: 0.70),
                ),
                onPressed: widget.onShare,
              ),
            const SizedBox(width: 10),
            _ContextChip(
              category: item.category ?? _TimelineCategory.unknown,
              onPressed: widget.onFixCategory,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          headline,
          style: TextStyle(
            color: cs.onSurface,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          insight,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.78),
            fontWeight: FontWeight.w600,
            height: 1.35,
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState:
              _open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox(height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.onSurface.withValues(alpha: 0.12)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.spa_outlined,
                    color: cs.onSurface.withValues(alpha: 0.80),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      preGame,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (item.isFuture) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => setState(() => _open = !_open),
              icon: Icon(
                Icons.spa_outlined,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.70),
              ),
              label: Text(
                _open ? "Hide pre‑game" : "Pre‑game",
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AuraCard extends StatelessWidget {
  const _AuraCard({required this.aura, required this.child});
  final _Aura aura;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              if (isLight)
                BoxShadow(
                  color: aura.shadow.withValues(alpha: 0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
            ],
          ),
          child: GlassCard(
            blurSigma: 12,
            child: child,
          ),
        ),
        Positioned(
          left: 0,
          top: 10,
          bottom: 10,
          child: Container(
            width: 6,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(22),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  aura.edge.withValues(alpha: 0.00),
                  aura.edge.withValues(alpha: 0.55),
                  aura.edge.withValues(alpha: 0.00),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: aura.edge.withValues(alpha: 0.18),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContextChip extends StatelessWidget {
  const _ContextChip({required this.category, this.onPressed});
  final _TimelineCategory category;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = switch (category) {
      _TimelineCategory.business => "Business",
      _TimelineCategory.life => "Life",
      _TimelineCategory.unknown => "Unclear",
    };
    final icon = switch (category) {
      _TimelineCategory.business => Icons.work_outline_rounded,
      _TimelineCategory.life => Icons.spa_outlined,
      _TimelineCategory.unknown => Icons.help_outline_rounded,
    };

    final bg = cs.onSurface.withValues(alpha: 0.06);
    final border = cs.onSurface.withValues(alpha: 0.12);

    return InkWell(
      onTap: category == _TimelineCategory.unknown ? onPressed : null,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: cs.onSurface.withValues(alpha: 0.70)),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.78),
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPills extends StatelessWidget {
  const _FilterPills({
    required this.filter,
    required this.counts,
    required this.onChanged,
  });

  final _TimelineFilter filter;
  final _Counts counts;
  final ValueChanged<_TimelineFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget pill(_TimelineFilter f, String label) {
      final selected = f == filter;
      return InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => onChanged(f),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? cs.onSurface.withValues(alpha: 0.08)
                : cs.onSurface.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: cs.onSurface.withValues(alpha: selected ? 0.14 : 0.10),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.86),
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        pill(_TimelineFilter.all, "All tasks (${counts.all})"),
        const SizedBox(width: 10),
        pill(_TimelineFilter.business, "Business (${counts.business})"),
        const SizedBox(width: 10),
        pill(_TimelineFilter.life, "Life (${counts.life})"),
      ],
    );
  }
}

class _SearchPill extends StatelessWidget {
  const _SearchPill({required this.controller, required this.onChanged});
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: cs.onSurface.withValues(alpha: 0.65)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.92),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              tooltip: "Clear",
              icon: Icon(Icons.close_rounded,
                  color: cs.onSurface.withValues(alpha: 0.65)),
              onPressed: () {
                controller.clear();
                onChanged("");
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
        ],
      ),
    );
  }
}

_Aura _auraFor(_TimelineCategory category, ColorScheme cs) {
  switch (category) {
    case _TimelineCategory.business:
      return const _Aura(
        edge: Color(0xFF2C7A7B), // deep teal
        shadow: Color(0xFF2C7A7B),
        core: Color(0xFF2C7A7B),
      );
    case _TimelineCategory.life:
      return const _Aura(
        edge: Color(0xFFB76E79), // soft rose
        shadow: Color(0xFFB76E79),
        core: Color(0xFFB76E79),
      );
    case _TimelineCategory.unknown:
      return _Aura(
        edge: cs.onSurface.withValues(alpha: 0.35),
        shadow: cs.onSurface,
        core: cs.onSurface.withValues(alpha: 0.30),
      );
  }
}

class _Aura {
  const _Aura({required this.edge, required this.shadow, required this.core});
  final Color edge;
  final Color shadow;
  final Color core;
}

enum _TimelineCategory { business, life, unknown }

enum _TimelineFilter {
  all,
  business,
  life;

  bool matches(_TimelineCategory c) {
    return switch (this) {
      all => true,
      business => c == _TimelineCategory.business,
      life => c == _TimelineCategory.life,
    };
  }
}

class _Counts {
  _Counts({required this.all, required this.business, required this.life});
  final int all;
  final int business;
  final int life;

  static _Counts from(List<_TimelineItem> items) {
    var b = 0;
    var l = 0;
    for (final i in items) {
      final c = i.category ?? _TimelineCategory.unknown;
      if (c == _TimelineCategory.business) b++;
      if (c == _TimelineCategory.life) l++;
    }
    return _Counts(all: items.length, business: b, life: l);
  }
}

class _TimelineItem {
  _TimelineItem({
    String? id,
    this.time,
    this.headline,
    this.insight,
    this.preGame,
    required this.isFuture,
    this.category,
  }) : id = id ?? UniqueKey().toString();

  final String id;
  // Nullable to survive hot-reload schema changes (old instances may have null).
  final String? time;
  final String? headline;
  final String? insight;
  final String? preGame;
  final bool isFuture;
  final _TimelineCategory? category;

  _TimelineItem copyWith({_TimelineCategory? category}) {
    return _TimelineItem(
      id: id,
      time: time,
      headline: headline,
      insight: insight,
      preGame: preGame,
      isFuture: isFuture,
      category: category ?? this.category,
    );
  }
}

