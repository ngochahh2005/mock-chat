import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/chat/domain/repository/chat_repository.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/chat_detail/chat_detail_page.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/widget/sticker_panel.dart';
import 'package:base_bloc_3/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ChatTabBar extends StatefulWidget {
  final TextEditingController _controller;
  final FocusNode focusNode;
  final ChatDetailPage widget;

  const ChatTabBar({
    super.key,
    required TextEditingController controller,
    required this.focusNode,
    required this.widget,
  }) : _controller = controller;

  @override
  State<StatefulWidget> createState() => ChatTabBarState();
}

class ChatTabBarState extends State<ChatTabBar> {
  bool _showSticker = false;
  String? _selectedSticker;

  Future<void> _sendCurrentContent() async {
    final text = widget._controller.text.trim();
    final sticker = _selectedSticker;
    if (text.isEmpty && sticker == null) return;

    // Reset the composer immediately so the UI does not wait for the network.
    widget._controller.clear();
    if (text.isNotEmpty) {
      widget.focusNode.requestFocus();
    } else {
      widget.focusNode.unfocus();
    }
    setState(() {
      _selectedSticker = null;
      _showSticker = false;
    });

    final sends = <Future<Either<BaseError, void>>>[];
    if (text.isNotEmpty) {
      sends.add(getIt<ChatRepo>().sendMessage(widget.widget.roomId, text));
    }
    if (sticker != null) {
      sends.add(getIt<ChatRepo>().sendStickerMessage(
        roomId: widget.widget.roomId,
        stickerPath: sticker,
      ));
    }

    final results = await Future.wait(sends);
    for (final result in results) {
      result.fold(
        (error) => debugPrint('Gửi nội dung thất bại: $error'),
        (_) {},
      );
    }
  }

  Future<void> uploadPicture() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return;
    }

    final result = await getIt<ChatRepo>().sendImageMessage(
      roomId: widget.widget.roomId,
      image: image,
    );

    result.fold(
      (error) {
        debugPrint('Gửi ảnh thất bại: $error');
      },
      (_) {
        debugPrint('Gửi ảnh thành công');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 12,
          children: [
            // send picture
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: Color(0xffF6F6F6),
                borderRadius: BorderRadius.circular(100),
              ),
              child: IconButton(
                onPressed: uploadPicture,
                icon: Icon(
                  CupertinoIcons.photo,
                  color: Color(0xff999999),
                ),
              ),
            ),

            // input message
            Expanded(
              child: TextField(
                controller: widget._controller,
                focusNode: widget.focusNode,
                onTap: () {
                  if (_showSticker) {
                    setState(() {
                      _showSticker = false;
                    });
                  }
                  widget.focusNode.requestFocus();
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffF6F6F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      setState(() {
                        _showSticker = !_showSticker;
                      });
                    },
                    icon: Icon(
                      _showSticker
                          ? CupertinoIcons.smiley_fill
                          : CupertinoIcons.smiley,
                      color:
                          _showSticker ? Color(0xff4356B4) : Color(0xff999999),
                      size: 30,
                    ),
                  ),
                  hintText: S.current.enter_message,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Color(0xff676767),
                  ),
                ),
                cursorColor: Color(0xff393939),
                textInputAction: TextInputAction.send,
              ),
            ),

            // send button
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget._controller,
              builder: (context, value, child) {
                final hasContent = value.text.trim().isNotEmpty || _selectedSticker != null;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: hasContent
                      ? IconButton(
                          key: const ValueKey('send'),
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xff4356B4),
                          ),
                          onPressed: () {
                            _sendCurrentContent();
                          },
                        )
                      : const SizedBox(
                          key: ValueKey('empty'),
                          width: 0,
                          height: 48,
                        ),
                );
              },
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _showSticker
              ? StickerPanel(
                  key: const ValueKey('sticker-panel'),
                  selectedSticker: _selectedSticker,
                  onStickerSelected: (sticker) {
                    setState(() {
                      _selectedSticker = _selectedSticker == sticker ? null : sticker;
                    });
                  },
                )
              : const SizedBox(
                  key: ValueKey('no-sticker'),
                ),
        ),
      ],
    );
  }
}
