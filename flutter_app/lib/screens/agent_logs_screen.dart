import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../models/api_models.dart';
import 'result_screen.dart';

class AgentLogsScreen extends StatefulWidget {
  final OrchestratorResponse? response;
  const AgentLogsScreen({super.key, this.response});

  @override
  State<AgentLogsScreen> createState() => _AgentLogsScreenState();
}

class _AgentLogsScreenState extends State<AgentLogsScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  final List<Color> _stepColors = [
    const Color(0xFF00BFA5),
    AppTheme.emeraldGreen,
    const Color(0xFF4CAF50),
    const Color(0xFF8BC34A),
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStepColor(int index) => _stepColors[index % _stepColors.length];

  Widget _buildLogItem(Map<String, dynamic> stepData, int index, bool isLast) {
    final color = _getStepColor(index);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + index * 150),
      curve: Curves.easeOutCubic,
      builder: (context, val, child) => Opacity(
        opacity: val,
        child: Transform.translate(offset: Offset(30 * (1 - val), 0), child: child),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timeline
            Column(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.firaCode(color: color, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: color.withValues(alpha: 0.25),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ]),
            const SizedBox(width: 16),
            // Card
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBlue,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withValues(alpha: 0.25)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '[${stepData['agent']}]',
                              style: GoogleFonts.firaCode(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '✓ 200 OK',
                              style: GoogleFonts.firaCode(color: Colors.greenAccent, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        stepData['step'] ?? '',
                        style: GoogleFonts.inter(
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
                        ),
                        child: Text(
                          '> ${stepData['result'] ?? 'Processing...'}',
                          style: GoogleFonts.firaCode(
                            color: color.withValues(alpha: 0.9),
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDeepBlue,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const Icon(LucideIcons.arrowLeft, color: AppTheme.textLight, size: 18),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Execution Trace',
              style: GoogleFonts.firaCode(
                color: AppTheme.textLight,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              'Multi-Agent Pipeline',
              style: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Terminal header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: AppTheme.lightBlue,
              child: Row(
                children: [
                  const Icon(LucideIcons.terminal, color: AppTheme.emeraldGreen, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    'ServiceSathi Orchestrator v2.0 — Execution Started',
                    style: GoogleFonts.firaCode(color: AppTheme.emeraldGreen, fontSize: 11),
                  ),
                ],
              ),
            ),
            Expanded(
              child: widget.response == null
                  ? Center(
                      child: Text(
                        'Waiting for execution trace...',
                        style: GoogleFonts.firaCode(color: AppTheme.textMuted),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      itemCount: widget.response!.agentTrace.length,
                      itemBuilder: (context, index) => _buildLogItem(
                        widget.response!.agentTrace[index],
                        index,
                        index == widget.response!.agentTrace.length - 1,
                      ),
                    ),
            ),
            if (widget.response != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ResultScreen(response: widget.response!)),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: AppTheme.emeraldGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.emeraldGreen.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.mapPin, color: Colors.black, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          'View Provider & Map',
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(LucideIcons.arrowRight, color: Colors.black, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
