import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import 'agent_logs_screen.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class HomeChatScreen extends StatefulWidget {
  const HomeChatScreen({super.key});

  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();
  late stt.SpeechToText _speech;
  late AnimationController _pulseController;
  bool _isLoading = false;
  bool _isListening = false;

  List<ChatMessage> messages = [
    ChatMessage(
      text: '👋 Assalam-o-Alaikum! Main ServiceSathi AI hoon.\n\nKaunsi service chahiye? AC, Plumber, Electrician — sab kuch ek tap mein! 🔍',
      isUser: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) {
          setState(() => _isListening = false);
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) => setState(() {
          _controller.text = val.recognizedWords;
        }));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _submitRequest([String? prefilledText]) async {
    final text = prefilledText ?? _controller.text.trim();
    if (text.isEmpty) return;
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }

    setState(() {
      messages.insert(0, ChatMessage(text: text, isUser: true));
      _controller.clear();
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();

    try {
      final response = await _apiService.sendRequest(text);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        final name = response.recommendedProvider?.name ?? 'No provider';
        final dist = response.recommendedProvider?.distance ?? 0;
        final rating = response.recommendedProvider?.rating ?? 0;
        messages.insert(0, ChatMessage(
          text: '✅ Mila! $name\n⭐ $rating stars • 📍 ${dist}km away\n\nDetails, map & booking dekhein 👇',
          isUser: false,
        ));
      });
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        Navigator.push(context, PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => AgentLogsScreen(response: response),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
            position: animation.drive(Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic))),
            child: child,
          ),
        ));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        messages.insert(0, ChatMessage(
          text: '❌ Backend connection error. Baad mein try karein.',
          isUser: false,
        ));
      });
    }
  }

  Widget _buildBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: message.isUser ? 60 : 16,
          right: message.isUser ? 16 : 60,
          top: 6,
          bottom: 6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: message.isUser
              ? const LinearGradient(
                  colors: [AppTheme.emeraldGreen, Color(0xFF00BFA5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: message.isUser ? null : AppTheme.lightBlue,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: message.isUser ? const Radius.circular(20) : const Radius.circular(4),
            bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(20),
          ),
          border: Border.all(
            color: message.isUser
                ? AppTheme.emeraldGreen.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: message.isUser
                  ? AppTheme.emeraldGreen.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Text(
          message.text,
          style: GoogleFonts.inter(
            color: message.isUser ? Colors.black : AppTheme.textLight,
            fontSize: 14,
            height: 1.55,
            fontWeight: message.isUser ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, IconData icon) {
    return GestureDetector(
      onTap: () => _submitRequest(label),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.lightBlue,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.emeraldGreen.withValues(alpha: 0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.emeraldGreen.withValues(alpha: 0.03),
              blurRadius: 6,
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.emeraldGreen, size: 14),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppTheme.textLight,
                fontWeight: FontWeight.w600,
                fontSize: 12,
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.emeraldGreen.withValues(alpha: 0.2)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    'assets/icon/app_icon.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ServiceSathi AI',
                  style: GoogleFonts.outfit(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.emeraldGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Online • AI Powered',
                      style: GoogleFonts.inter(
                        color: AppTheme.emeraldGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const Icon(LucideIcons.moreVertical, color: AppTheme.textLight, size: 18),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
          // Quick Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.black,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildQuickChip('AC Repair', LucideIcons.snowflake),
                  _buildQuickChip('Plumber', LucideIcons.wrench),
                  _buildQuickChip('Electrician', LucideIcons.zap),
                  _buildQuickChip('Tutor', LucideIcons.bookOpen),
                  _buildQuickChip('Beautician', LucideIcons.scissors),
                  _buildQuickChip('Painter', LucideIcons.paintbrush),
                ],
              ),
            ),
          ),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.05)),
          // Chat
          Expanded(
            child: ListView.builder(
              reverse: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8, right: 60),
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlue,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(4),
                          ),
                          border: Border.all(
                            color: AppTheme.emeraldGreen.withValues(
                              alpha: 0.1 + 0.15 * _pulseController.value,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.brain,
                              color: AppTheme.emeraldGreen,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI soch raha hai...',
                              style: GoogleFonts.inter(
                                color: AppTheme.emeraldGreen.withValues(
                                  alpha: 0.5 + 0.5 * _pulseController.value,
                                ),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return _buildBubble(messages[_isLoading ? index - 1 : index]);
              },
            ),
          ),
          // Input
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.8),
                  border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: _isListening
                                ? Colors.redAccent.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: TextField(
                          controller: _controller,
                          style: GoogleFonts.inter(color: AppTheme.textLight, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: _isListening ? '🎤 Listening...' : 'Service request likhein...',
                            hintStyle: GoogleFonts.inter(
                              color: _isListening ? Colors.redAccent : AppTheme.textMuted,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onSubmitted: (v) => _submitRequest(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _listen,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isListening ? Colors.redAccent.withValues(alpha: 0.2) : AppTheme.lightBlue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isListening ? Colors.redAccent : Colors.white.withValues(alpha: 0.1),
                          ),
                          boxShadow: _isListening
                              ? [
                                  BoxShadow(
                                    color: Colors.redAccent.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  )
                                ]
                              : [],
                        ),
                        child: Icon(
                          _isListening ? LucideIcons.micOff : LucideIcons.mic,
                          color: _isListening ? Colors.redAccent : AppTheme.textLight,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _submitRequest(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: AppTheme.emeraldGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.emeraldGreen.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(LucideIcons.send, color: Colors.black, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
