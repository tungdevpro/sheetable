# sheetable

A customizable and scrollable bottom sheet widget for Flutter.

## ✨ Features

- Drag to resize
- Optional full height
- Auto expand when content scrolls to top
- Custom scrollable content
- `onSheetHidden` callback

## 🚀 Usage

```dart
SheetableWidget(
    contentBuilder: (scrollController) {
        return ListView.builder(
            controller: scrollController,
            itemCount: 20,
            itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
        );
    },
    onSheetHidden: () => print('Sheet hidden'),
)
```