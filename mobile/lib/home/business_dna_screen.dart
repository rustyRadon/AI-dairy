import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../shared/ui/glass_card.dart";
import "../onboarding/widgets/ore_avatar.dart";
import "../shared/widgets/screen_frame.dart";
import "../shared/widgets/white_card.dart";

class BusinessDnaScreen extends StatefulWidget {
  const BusinessDnaScreen({
    super.key,
    required this.userName,
    this.scrollKnowledgeOnOpen = false,
    this.onKnowledgeScrollConsumed,
  });
  final String userName;
  final bool scrollKnowledgeOnOpen;
  final VoidCallback? onKnowledgeScrollConsumed;

  @override
  State<BusinessDnaScreen> createState() => _BusinessDnaScreenState();
}

class _BusinessDnaScreenState extends State<BusinessDnaScreen> {
  final GlobalKey _knowledgeAnchorKey = GlobalKey();
  final List<_Memory> _memories = [
    _Memory(title: "Voice", subtitle: "Minimal · calm · direct"),
    _Memory(title: "Offer", subtitle: "Founder launch support"),
    _Memory(title: "Aesthetic", subtitle: "Modern / monochrome"),
    _Memory(title: "Focus", subtitle: "SaaS growth"),
  ];

  final List<_Source> _sources = [
    _Source(
      asset: "assets/images/browser-safari-svgrepo-com.svg",
      label: "Website",
      placeholder: "Add your site",
    ),
    _Source(
      asset: "assets/images/twitter-logo-svgrepo-com.svg",
      label: "X / Twitter",
      placeholder: "Add your handle",
    ),
    _Source(
      asset: "assets/images/instagram-2-1-logo-svgrepo-com.svg",
      label: "Instagram",
      placeholder: "Add your handle",
    ),
  ];

  Future<void> _editSource(int index) async {
    final s = _sources[index];
    if (s.status == _SourceStatus.learning) return;

    final controller = TextEditingController(text: s.value ?? "");
    final cs = Theme.of(context).colorScheme;

    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add ${s.label}"),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: s.placeholder,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: cs.secondary,
                foregroundColor: cs.onSecondary,
              ),
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return;

    await _setLearning(index, trimmed);
  }

  @override
  void initState() {
    super.initState();
    if (widget.scrollKnowledgeOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToKnowledgeBubbles());
    }
  }

  @override
  void didUpdateWidget(covariant BusinessDnaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollKnowledgeOnOpen && !oldWidget.scrollKnowledgeOnOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToKnowledgeBubbles());
    }
  }

  void _scrollToKnowledgeBubbles() {
    final ctx = _knowledgeAnchorKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
        alignment: 0.1,
      );
    }
    widget.onKnowledgeScrollConsumed?.call();
  }

  Future<void> _setLearning(int index, String enteredValue) async {
    final s = _sources[index];
    if (s.status == _SourceStatus.learning) return;

    setState(() {
      s.status = _SourceStatus.learning;
    });
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() {
      s.value = enteredValue;
      s.status = _SourceStatus.ready;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ScreenFrame(
      title: "Business DNA",
      subtitle: "What Ọ̀rẹ́ learns about you — the little facts Ọ̀rẹ́ can remember.",
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      trailing: SizedBox(
        width: 48,
        child: Align(
          alignment: Alignment.centerRight,
          child: ClipOval(
            child: ColoredBox(
              color: cs.onSurface.withValues(alpha: 0.08),
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: OreMascot(height: 18),
              ),
            ),
          ),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          Text(
            "Vibe meter",
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.88),
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          _VibeMeterCard(cs: cs),
          const SizedBox(height: 18),
          KeyedSubtree(
            key: _knowledgeAnchorKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Knowledge bubbles",
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: _memories.length,
                  itemBuilder: (context, i) {
                    final m = _memories[i];
                    return _MemoryBubble(
                      memory: m,
                      onForget: () async {
                        setState(() => m.isDeleting = true);
                        await Future<void>.delayed(const Duration(milliseconds: 260));
                        if (!mounted) return;
                        setState(() => _memories.removeWhere((x) => x.id == m.id));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "Where Ọ̀rẹ́ Studies",
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.88),
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          WhiteCard(
            child: Column(
              children: [
                for (var i = 0; i < _sources.length; i++) ...[
                  _SourceRow(
                    source: _sources[i],
                    onEdit: () => _editSource(i),
                    onRemove: () {
                      setState(() {
                        _sources[i].value = null;
                        _sources[i].status = _SourceStatus.idle;
                      });
                    },
                  ),
                  if (i != _sources.length - 1) const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VibeMeterCard extends StatelessWidget {
  const _VibeMeterCard({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    // Soft "pulse": faint glow, not a loud block.
    final glow = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFF36CFC9).withValues(alpha: isLight ? 0.10 : 0.08),
        const Color(0xFF5B8CFF).withValues(alpha: isLight ? 0.08 : 0.06),
      ],
    );

    return Stack(
      children: [
        // Base neutral surface (monochrome/cool).
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: cs.onSurface.withValues(alpha: 0.10)),
            boxShadow: [
              if (isLight)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
        ),
        // Faint glow overlay.
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: glow,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _KeyValueRow(k: "Aesthetic", v: "Minimalist / Modern"),
              SizedBox(height: 10),
              _KeyValueRow(k: "Current goal", v: "Scaling SaaS"),
              SizedBox(height: 10),
              _KeyValueRow(k: "Tone", v: "Calm · clear · kind"),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemoryBubble extends StatefulWidget {
  const _MemoryBubble({required this.memory, required this.onForget});
  final _Memory memory;
  final VoidCallback onForget;

  @override
  State<_MemoryBubble> createState() => _MemoryBubbleState();
}

class _MemoryBubbleState extends State<_MemoryBubble> {
  bool _armed = false;

  void _armBriefly() {
    if (_armed) return;
    setState(() => _armed = true);
    Future<void>.delayed(const Duration(milliseconds: 900)).then((_) {
      if (!mounted) return;
      setState(() => _armed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final deleting = widget.memory.isDeleting;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: deleting ? 1 : 0),
      builder: (context, t, child) {
        // "Pop": expand slightly, then snap-shrink + fade.
        final scale = t < 0.28
            ? (1 + (0.10 * (t / 0.28)))
            : (1.10 - (0.18 * ((t - 0.28) / 0.72)));
        final fadeT = ((t - 0.12) / 0.88).clamp(0.0, 1.0);
        final opacity = 1 - fadeT;

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      child: GlassCard(
        blurSigma: 14,
        // Keep monochrome/cool; create depth via border + shadow.
        tint: cs.surfaceContainerHighest,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.bubble_chart_outlined,
                  color: cs.onSurface.withValues(alpha: 0.70),
                  size: 18,
                ),
                const Spacer(),
                GestureDetector(
                  onLongPress: _armBriefly,
                  child: IconButton(
                    tooltip: "Forget",
                    icon: Icon(
                      Icons.delete_outline,
                      color: _armed
                          ? cs.error.withValues(alpha: 0.85)
                          : cs.onSurface.withValues(alpha: 0.55),
                      size: 18,
                    ),
                    onPressed: deleting ? null : widget.onForget,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              widget.memory.title,
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.memory.subtitle,
              style: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({required this.k, required this.v});
  final String k;
  final String v;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            k,
            style: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.70),
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ),
        Text(
          v,
          style: TextStyle(
            color: cs.onSurface.withValues(alpha: 0.92),
            fontWeight: FontWeight.w800,
            fontSize: 12.5,
          ),
        ),
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.source,
    required this.onEdit,
    required this.onRemove,
  });

  final _Source source;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Use supporting accent (green) for progress so it's readable on light mode.
    final brand = cs.tertiary;
    final canEdit = source.status != _SourceStatus.learning;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          height: 34,
          child: Center(
            child: SvgPicture.asset(
              source.asset,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              placeholderBuilder: (_) => Icon(
                Icons.public,
                size: 18,
                color: cs.onSurface.withValues(alpha: 0.70),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                source.label,
                style: TextStyle(
                  color: cs.onSurface.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                ),
              ),
              const SizedBox(height: 2),
              if (source.value == null)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    alignment: Alignment.centerLeft,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(
                      color: cs.onSurface.withValues(alpha: 0.14),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: canEdit ? onEdit : null,
                  child: Text(
                    source.placeholder,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.86),
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: canEdit ? onEdit : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      source.value!,
                      style: TextStyle(
                        color: cs.onSurface.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              if (source.status == _SourceStatus.learning) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: brand,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Learning…",
                      style: TextStyle(
                        color: brand,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (source.value != null)
          IconButton(
            tooltip: "Remove",
            icon: Icon(
              Icons.delete_outline,
              color: cs.onSurface.withValues(alpha: 0.60),
              size: 18,
            ),
            onPressed: canEdit ? onRemove : null,
          ),
      ],
    );
  }
}

class _Memory {
  _Memory({required this.title, required this.subtitle});
  final String id = UniqueKey().toString();
  final String title;
  final String subtitle;
  bool isDeleting = false;
}

enum _SourceStatus { idle, learning, ready }

class _Source {
  _Source({
    required this.asset,
    required this.label,
    required this.placeholder,
  });

  final String asset;
  final String label;
  final String placeholder;
  String? value;
  _SourceStatus status = _SourceStatus.idle;
}

