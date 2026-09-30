import 'package:base_bloc_3/common/external_lib.dart';
import 'package:flutter/cupertino.dart';

class CustomUserAvatar extends StatelessWidget {
  const CustomUserAvatar({
    super.key,
    required this.avatarUrl,
    this.size = 44,
  });

  final String? avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: const BoxDecoration(
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
        child: avatarUrl != null && avatarUrl!.isNotEmpty
            ? ClipOval(
          child: CachedNetworkImage(
            imageUrl: avatarUrl!,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => Icon(
              CupertinoIcons.person_solid,
              color: Colors.white,
              size: size * 0.6,
            ),
          ),
        )
            : Icon(
          CupertinoIcons.person_solid,
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }
}