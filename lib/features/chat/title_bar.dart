import 'package:chat_app_flutter/features/shared/divider_wrapper.dart';
import 'package:material_ui/material_ui.dart';
import 'package:window_manager/legacy.dart';

class Titlebar extends StatefulWidget {
  const Titlebar({super.key});

  @override
  State<Titlebar> createState() => _TitlebarState();
}

class _TitlebarState extends State<Titlebar> {
  late final Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadTitlebarData();
  }

  Future<void> _loadTitlebarData() async {
    await windowManager.ensureInitialized();
    await windowManager.waitUntilReadyToShow(const WindowOptions(), () async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      await windowManager.focus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const double iconSize = 16;

    return FutureBuilder<void>(
      future: _future,
      builder: (context, snapshot) {
        return DragToMoveArea(
          child: Material(
            color: colorScheme.surfaceContainerLowest,
            child: SizedBox(
              height: 32,
              child: Stack(
                children: [
                  // apply the divider line
                  Row(
                    children: [
                      const SizedBox(width: 72),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: dividerX(),
                        ),
                      ),
                    ],
                  ),

                  // window title
                  const Center(child: Text('Chat App')),

                  // buttons to minimize, maximize, exit
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: windowManager.minimize,
                          icon: const Icon(
                            Icons.remove_outlined,
                            size: iconSize,
                          ),
                        ),
                        IconButton(
                          onPressed: () async =>
                              await windowManager.isMaximized()
                              ? windowManager.unmaximize()
                              : windowManager.maximize(),
                          icon: const Icon(
                            Icons.square_outlined,
                            size: iconSize,
                          ),
                        ),
                        IconButton(
                          onPressed: windowManager.close,
                          icon: const Icon(
                            Icons.close_outlined,
                            size: iconSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
