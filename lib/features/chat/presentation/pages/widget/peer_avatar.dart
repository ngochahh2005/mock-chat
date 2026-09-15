import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/chat_detail/chat_detail_page.dart';
import 'package:flutter/cupertino.dart';

class PeerAvatar extends StatelessWidget {
  const PeerAvatar({
    super.key,
    required this.widget,
  });

  final ChatDetailPage widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff4356b4),
              Color(0xff3DCFCF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          shape: BoxShape.circle,
        ),
        child: widget.peerInfo.avatar != null
            ? ClipOval(
          child: CachedNetworkImage(
            imageUrl: widget.peerInfo.avatar!,
            fit: BoxFit.cover,
          ),
        )
            : Icon(
          CupertinoIcons.person_solid,
          color: Colors.white,
        ),
      ),
    );
  }
}