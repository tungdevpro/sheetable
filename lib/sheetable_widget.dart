import 'package:flutter/material.dart';
import 'package:sheetable/sheetable_controller.dart';

class SheetableWidget extends StatefulWidget {
  const SheetableWidget({
    super.key,
    this.minHeight = 100,
    this.maxHeight = 500,
    this.expandToFullHeight = false,
    this.onSheetHidden,
    required this.contentBuilder,
  });

  final double minHeight;
  final double maxHeight;

  final bool expandToFullHeight;
  final VoidCallback? onSheetHidden;
  final Widget Function(ScrollController) contentBuilder;

  @override
  State<SheetableWidget> createState() => _CommonScrollBottomSheetState();
}

class _CommonScrollBottomSheetState extends State<SheetableWidget> {
  final SheetableController _controller = SheetableController();
  final ScrollController _scrollController = ScrollController();

  bool? isDraggingUp;
  late double _maxHeight = widget.maxHeight;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_scrollController.offset <= 0 && _scrollController.position.outOfRange && !_scrollController.position.atEdge) {
      if (_scrollController.offset <= -50) {
        _hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        _maxHeight = constraints.maxHeight - 30;
        if (widget.expandToFullHeight) _controller.height = _maxHeight;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragEnd: _onVerticalDragEnd,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              child: Container(
                height: 30,
                width: MediaQuery.sizeOf(context).width,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Colors.white),
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 12),
                  height: 5,
                  width: 48,
                  decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(99)),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: StreamBuilder<double>(
                stream: _controller.heightStream,
                initialData: _controller.height,
                builder: (_, snapshot) {
                  return AnimatedContainer(
                    height: snapshot.data,
                    color: Colors.white,
                    duration: const Duration(milliseconds: 300),
                    child: widget.contentBuilder(_scrollController),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final newHeight = _controller.height - details.delta.dy;

    if (newHeight >= widget.minHeight && newHeight <= _maxHeight) {
      isDraggingUp = details.delta.dy <= 0;

      _controller.height = newHeight;
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (isDraggingUp! && _controller.visible) {
      _show();
    } else if (!isDraggingUp! && !_controller.visible) {
      _hide();
    } else {
      _controller.visible = isDraggingUp!;
    }
  }

  void _hide() {
    _controller.height = widget.minHeight;
    widget.onSheetHidden?.call();
  }

  void _show() {
    _controller.height = _maxHeight;
  }
}
