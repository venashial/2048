import 'package:flutter/material.dart';
import 'package:game2048/board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(
        scaffoldBackgroundColor:
            const HSLColor.fromAHSL(1, 49, 0.53, 0.96).toColor(),
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: '2048 Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  final _board = GameBoard(size: 4);
  int _score = 0;

  _MyHomePageState() {
    _score = _board.total;
  }

  void _swipe(String direction) {
    print(direction);
    setState(() {
      _score = _board.total;
      _board.move(direction);
      _board.addRandomTile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '$_score',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: const HSLColor.fromAHSL(1, 30, 0.08, 0.43).toColor(),
                  ),
                ),
                const Spacer(), // use Spacer
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const HSLColor.fromAHSL(1, 1, 0, 0.5).toColor(),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'BEST\n',
                            style: TextStyle(
                              color: const HSLColor.fromAHSL(1, 1, 0, 0.8)
                                  .toColor(),
                            ),
                          ),
                          TextSpan(
                            text: '$_score',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity! > 0) _swipe('right');
                if (details.primaryVelocity! < 0) _swipe('left');
              },
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! > 0) _swipe('down');
                if (details.primaryVelocity! < 0) _swipe('up');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const HSLColor.fromAHSL(1, 29, 0.17, 0.68).toColor(),
                ),
                padding: const EdgeInsets.all(15),
                child: GridView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: 16,
                    itemBuilder: (BuildContext ctx, index) {
                      var tileColors = {
                        '0': const HSLColor.fromAHSL(0.35, 30, 0.37, 0.89)
                            .toColor(),
                        '2': const HSLColor.fromAHSL(1, 30, 0.37, 0.89)
                            .toColor(),
                        '4': const HSLColor.fromAHSL(1, 39, 0.51, 0.86)
                            .toColor(),
                        '8': const HSLColor.fromAHSL(1, 28, 0.82, 0.71)
                            .toColor(),
                        '16': const HSLColor.fromAHSL(1, 21, 0.88, 0.67)
                            .toColor(),
                        '32': const HSLColor.fromAHSL(1, 12, 0.89, 0.67)
                            .toColor(),
                        '64': const HSLColor.fromAHSL(1, 11, 0.91, 0.60)
                            .toColor(),
                        '128': const HSLColor.fromAHSL(1, 45, 0.77, 0.69)
                            .toColor(),
                      };
                      int column = index % 4;
                      int row = (index - column) ~/ 4;
                      int value = _board.tiles[column][row];
                      Widget child = const Text('');
                      if (value != 0) {
                        child = Text(
                          (value).toString(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: const HSLColor.fromAHSL(1, 30, 0.08, 0.43)
                                .toColor(),
                          ),
                        );
                      }
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: tileColors[value.toString()],
                          ),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          child: child);
                    }),
              ),
            ),
            const SizedBox(height: 40),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.0,
                  color: const HSLColor.fromAHSL(1, 0, 0, 0.5).toColor(),
                ),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'How to play: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text:
                        'Swipe to move the tiles. Tiles with the same number merge into one when they touch. Add them up to reach 2048!',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
