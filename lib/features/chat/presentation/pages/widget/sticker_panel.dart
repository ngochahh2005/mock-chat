import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/service/supabase_storage/supabase_storage_service.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/generated/l10n.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StickerPanel extends StatefulWidget {
  final void Function(String stickerId) onStickerSelected;
  final String? selectedSticker;

  const StickerPanel({
    super.key,
    required this.onStickerSelected,
    this.selectedSticker,
  });

  @override
  State<StickerPanel> createState() => _StickerPanelState();
}

class _StickerPanelState extends State<StickerPanel> {
  late final Future<Map<String, List<String>>> _stickerSetsFuture;

  @override
  void initState() {
    super.initState();
    _stickerSetsFuture = getIt<SupabaseStorageService>().listStickerSets();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<String>>>(
      future: _stickerSetsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 330,
            child: SpinKitFoldingCube(
              color: Color(0xff4356B4),
              size: 50,
            ),
          );
        }
        if (snapshot.hasError) {
          debugPrint('Không tải được sticker từ Supabase: ${snapshot.error}');
          return SizedBox(
            height: 280,
            child: Center(child: Text(S.of(context).sticker_load_error)),
          );
        }
        final sets = snapshot.data ?? const <String, List<String>>{};
        if (sets.isEmpty) {
          return SizedBox(
            height: 280,
            child: Center(child: Text(S.of(context).no_stickers)),
          );
        }
        final names = sets.keys.toList();
        return SizedBox(
          height: 330,
          child: DefaultTabController(
            length: names.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: const Color(0xff4356B4),
                  unselectedLabelColor: const Color(0xff999999),
                  tabs: names.map((name) => Tab(text: name)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: names.map((name) {
                      final stickers = sets[name]!;
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: stickers.length,
                        itemBuilder: (context, index) {
                          final sticker = stickers[index];
                          final imageUrl = getIt<SupabaseStorageService>().getStickerUrl(sticker);
                          final isSelected = widget.selectedSticker == sticker;
                          return GestureDetector(
                            onTap: () => widget.onStickerSelected(sticker),
                            child: AnimatedScale(
                              scale: isSelected ? 1.1 : 1,
                              alignment: Alignment.center,
                              duration: const Duration(milliseconds: 320),
                              curve: Curves.easeOutBack,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 240),
                                curve: Curves.easeOut,
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors: [
                                            const Color(0xff4356B4).withOpacity(0.20),
                                            const Color(0xff8290E8).withOpacity(0.08),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  color: isSelected ? null : const Color(0xffFAFAFC),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xff4356B4)
                                        : const Color(0xffEEEEF4),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xff4356B4).withOpacity(0.28),
                                            blurRadius: 14,
                                            spreadRadius: 1,
                                            offset: const Offset(0, 5),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Stack(
                                  children: [
                                    Center(child: CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.contain)),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: AnimatedScale(
                                        scale: isSelected ? 1 : 0,
                                        duration: const Duration(milliseconds: 240),
                                        curve: Curves.easeOutBack,
                                        child: const CircleAvatar(
                                          radius: 11,
                                          backgroundColor: Color(0xff4356B4),
                                          child: Icon(Icons.check_rounded, size: 15, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final phase = (((_controller.value * 3) - index).clamp(0.0, 1.0)).toDouble();
          return Opacity(
            opacity: 0.35 + (phase * 0.65),
            child: Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff4356B4)),
            ),
          );
        }),
      ),
    );
  }
}
