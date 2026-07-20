import 'package:flutter/material.dart';
import 'package:flutter_live2d/flutter_live2d.dart';

class _ModelDef {
  final String id;
  final String label;
  final String assetFolder;
  final String modelFile;
  final List<_Motion> motions;
  final int expressionCount;

  const _ModelDef({
    required this.id,
    required this.label,
    required this.assetFolder,
    required this.modelFile,
    required this.motions,
    required this.expressionCount,
  });
}

class _Motion {
  final String group;
  final int index;
  final String label;

  const _Motion(this.group, this.index, this.label);
}

const List<_ModelDef> _models = [
  _ModelDef(
    id: 'mao',
    label: 'Mao',
    assetFolder: 'assets/models/mao/',
    modelFile: 'mao_pro.model3.json',
    motions: [
      _Motion('Idle', 0, 'Idle'),
      _Motion('', 0, 'Motion 1'),
      _Motion('', 1, 'Motion 2'),
      _Motion('', 2, 'Motion 3'),
      _Motion('', 3, 'Special 1'),
      _Motion('', 4, 'Special 2'),
      _Motion('', 5, 'Special 3'),
    ],
    expressionCount: 8,
  ),
  // _ModelDef(
  //   id: 'icegirl',
  //   label: 'IceGirl',
  //   assetFolder: 'assets/models/icegirl/',
  //   modelFile: 'IceGirl.model3.json',
  //   motions: [],
  //   expressionCount: 0,
  // ),
  // _ModelDef(
  //   id: 'ren',
  //   label: 'Ren',
  //   assetFolder: 'assets/models/ren/',
  //   modelFile: 'ren.model3.json',
  //   motions: [
  //     _Motion('Idle', 0, 'Idle'),
  //     _Motion('', 0, 'Motion 1'),
  //     _Motion('', 1, 'Motion 2'),
  //   ],
  //   expressionCount: 5,
  // ),
];

class _Slot {
  _Slot(this.label) : controller = Live2DViewController();

  final String label;
  final Live2DViewController controller;

  _ModelDef selectedModel = _models.first;
  bool visible = true;
  double motionSpeed = 1.0;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<_Slot> _slots = [_Slot('Slot 1')];
  int _activeSlot = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (final s in _slots) {
      s.controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(child: _slotView(_slots[0])),

          Row(
            children: [
              SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => {_loadModel(_slots[0])},
                icon: const Icon(Icons.download_rounded, size: 18),
                label: Text('加载模型'),
              ),
            ],
          ),

          Row(
            children: [
              SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => {playMotion(_slots[0], _models[0].motions[3])},
                label: Text('Motion 1'),
              ),
              SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => {playMotion(_slots[0], _models[0].motions[4])},
                label: Text('Motion 2'),
              ),
              SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => {playMotion(_slots[0], _models[0].motions[5])},
                label: Text('Motion 3'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _slotView(_Slot slot) {
    final idx = _slots.indexOf(slot);
    return GestureDetector(
      onTap: () => setState(() => _activeSlot = idx),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Flutter background — always visible through the transparent Live2D view.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A237E), Color(0xFF880E4F)],
              ),
            ),
          ),
          if (slot.visible)
            Live2DView(controller: slot.controller)
          else
            const Center(
              child: Text(
                'Hidden',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ),
          Positioned(
            left: 8,
            top: 8,
            child: _badge(
              slot.label,
              color: _activeSlot == _slots.indexOf(slot)
                  ? const Color(0xFF7B9FE3)
                  : Colors.black54,
            ),
          ),
          // The status badge listens directly to the controller. Whenever the
          // controller's state changes, only this widget rebuilds.
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: ValueListenableBuilder<Live2DViewState>(
              valueListenable: slot.controller,
              builder: (_, state, widget) =>
                  _badge(_describe(state, slot), color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, {required Color color}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 11),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );

  String _describe(Live2DViewState s, _Slot slot) {
    if (!slot.visible) return 'Hidden — toggle to mount.';
    switch (s.lifecycle) {
      case Live2DLifecycle.detached:
        return 'Waiting for GL surface…';
      case Live2DLifecycle.attached:
        if (s.isLoadingModel) return 'Loading ${slot.selectedModel.label}…';
        if (s.lastError != null) {
          return '[${s.lastError!.code}] ${s.lastError!.message}';
        }
        if (s.isLoaded) {
          return '${s.loadedModel!.modelFileName}'
              '${s.isRenderingPaused ? ' (paused)' : ''}';
        }
        return 'GL surface ready.';
    }
  }

  Future<void> _loadModel(_Slot slot) async {
    final c = slot.controller;
    if (c.value.isLoadingModel) return;
    try {
      await c.whenAttached;
      await c.loadModel(
        modelDir: slot.selectedModel.assetFolder,
        modelFileName: slot.selectedModel.modelFile,
      );
    } on Live2DException catch (e) {
      _showMessage('${slot.label}: ${e.code}: ${e.message}');
    } catch (e) {
      _showMessage('${slot.label}: $e');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void playMotion(_Slot slot, _Motion motion) {
    slot.controller.startMotion(group: motion.group, index: motion.index);
  }
}
