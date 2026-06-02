import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/services/farmbrain_chat_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/chat/data/models/chat_message.dart';
import 'package:farmtec/features/chat/presentation/widgets/chat_drawer.dart';
import 'package:farmtec/features/chat/presentation/widgets/chat_empty_state.dart';
import 'package:farmtec/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:farmtec/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:farmtec/features/chat/presentation/widgets/chat_suggestions.dart';
import 'package:farmtec/features/chat/presentation/widgets/chat_typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmBrainChatScreen extends StatefulWidget {
  const FarmBrainChatScreen({super.key});

  static const String routeName = 'farmbrain_chat';

  @override
  State<FarmBrainChatScreen> createState() => _FarmBrainChatScreenState();
}

class _FarmBrainChatScreenState extends State<FarmBrainChatScreen>
    with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  final _chatService = FarmbrainChatService();
  bool _isTyping = false;

  final List<List<ChatMessage>> _conversations = [[]];
  int _activeConversation = 0;

  List<ChatMessage> get _messages => _conversations[_activeConversation];

  @override
  void initState() {
    super.initState();
    _conversations[0] = [
      ChatMessage(
        text:
            "Hello! I'm FarmBrain, your AI agriculture assistant. How can I help you today?",
        sender: ChatSender.ai,
        time: '09:00',
      ),
    ];
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isTyping) return;

    final userText = text.trim();
    setState(() {
      _messages.add(
        ChatMessage(
          text: userText,
          sender: ChatSender.user,
          time: _currentTime(),
        ),
      );
      _textController.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final reply = await _chatService.sendMessage(userText);
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: reply,
            sender: ChatSender.ai,
            time: _currentTime(),
          ),
        );
      });
      _scrollToBottom();
    } on FarmbrainChatException catch (_) {
      if (!mounted) return;
      setState(() => _isTyping = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).tr('connection_error')),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isTyping = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).tr('connection_error')),
        ),
      );
    }
  }

  String _currentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _newChat() {
    setState(() {
      _conversations.add([
        ChatMessage(
          text: 'New conversation started. How can I help you?',
          sender: ChatSender.ai,
          time: _currentTime(),
        ),
      ]);
      _activeConversation = _conversations.length - 1;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _chatService.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final bgColor = isDark ? Pallete.darkBackground : const Color(0xFFF9FAF7);
    final appBarBg = isDark ? Pallete.darkSurface : Colors.white;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;

    return Scaffold(
      backgroundColor: bgColor,
      drawer: ChatDrawer(
        isDark: isDark,
        l: l,
        conversations: _conversations,
        activeConversation: _activeConversation,
        onNewChat: _newChat,
        onConversationSelected: (i) => setState(() => _activeConversation = i),
      ),
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu_rounded, color: textColor),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Pallete.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              l.tr('farmbrain_ai'),
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_rounded,
              color: isDark ? Pallete.darkTextSecondary : Pallete.textHint,
            ),
            onPressed: () {
              setState(() {
                _conversations.add([
                  ChatMessage(
                    text: 'New conversation started. How can I help you?',
                    sender: ChatSender.ai,
                    time: _currentTime(),
                  ),
                ]);
                _activeConversation = _conversations.length - 1;
              });
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: isDark ? Pallete.darkOutline : const Color(0xFFEEF0EA),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? ChatEmptyState(isDark: isDark, l: l)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return ChatTypingIndicator(isDark: isDark);
                      }
                      return ChatMessageBubble(
                        message: _messages[index],
                        isDark: isDark,
                      );
                    },
                  ),
          ),
          if (_messages.length <= 2)
            ChatSuggestions(
              isDark: isDark,
              l: l,
              onSuggestionTap: _sendMessage,
            ),
          ChatInputBar(
            isDark: isDark,
            l: l,
            textController: _textController,
            focusNode: _focusNode,
            isSending: _isTyping,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
