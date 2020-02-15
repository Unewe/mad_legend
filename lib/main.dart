import 'package:flame/flame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:mad_legend/screens/home_screen.dart';
import 'package:mad_legend/store/player.dart';
import 'screens/screen_base.dart';

void main() async {
  FlameGame game = FlameGame();
  var app = MadLegends(game);

  runApp(app);

  Util flameUtil = Util();
  flameUtil.setLandscape();
  flameUtil.fullScreen();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent));

  VerticalDragGestureRecognizer verticalDrag = VerticalDragGestureRecognizer();
  verticalDrag.onUpdate = game.onVerticalUpdate;
  verticalDrag.onStart = game.onVerticalStart;
  verticalDrag.onEnd = game.onVerticalEnd;
  flameUtil.addGestureRecognizer(verticalDrag);

  HorizontalDragGestureRecognizer horizontalDrag =
      HorizontalDragGestureRecognizer();
  horizontalDrag.onUpdate = game.onHorizontalUpdate;
  horizontalDrag.onStart = game.onHorizontalStart;
  horizontalDrag.onEnd = game.onHorizontalEnd;
  flameUtil.addGestureRecognizer(horizontalDrag);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  tapper.onTapUp = game.onTapUp;
  flameUtil.addGestureRecognizer(tapper);
}

class MadLegends extends StatefulWidget {
  final FlameGame _game;

  MadLegends(this._game, {Key key}) : super(key: key);

  @override
  _MadLegendsState createState() => _MadLegendsState();
}

class _MadLegendsState extends State<MadLegends> {
  FocusNode nameFocusNode;
  TextEditingController nameController;
  Widget inputComponent;

  @override
  void initState() {
    nameController = TextEditingController();
    nameFocusNode = FocusNode();
    nameFocusNode.addListener(() {
      if (nameFocusNode.hasFocus) {
        widget._game.focusNode = nameFocusNode;
      } else {
        savePlayerName(nameController.text).then((value) {
          widget._game.flutterWidgetAction();
          Flame.util.fullScreen();
          widget._game.focusNode = null;
        });
      }
    });
    inputComponent = Container();
    super.initState();
  }

  showNameInput() {
    setState(() {
      inputComponent = _getNameInput();
    });
  }

  clearFlutterComponents() {
    setState(() {
      inputComponent = Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode focusScopeNode = FocusScope.of(context);
    widget._game.focusScopeNode = focusScopeNode;
    widget._game.showNameInput = showNameInput;
    widget._game.clearFlutterComponents = clearFlutterComponents;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[widget._game.widget, inputComponent],
        ),
      ),
    );
  }

  Widget _getNameInput() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Введите имя: ",
            style: TextStyle(
                color: Colors.white, fontSize: 40, fontFamily: "YagiDouble"),
          ),
          Container(
            child: TextFormField(
              decoration: InputDecoration(border: InputBorder.none),
              textAlign: TextAlign.left,
              toolbarOptions: ToolbarOptions(
                  copy: false, cut: false, paste: false, selectAll: true),
              focusNode: nameFocusNode,
              controller: nameController,
              autofocus: true,
              style: TextStyle(
                  backgroundColor: Color(0x66FFFFFF),
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: "YagiDouble"),
            ),
          ),
        ],
      ),
    );
  }
}

class FlameGame extends Game {
  Size size;
  Screen screen;
  FocusNode focusNode;
  FocusScopeNode focusScopeNode;
  Function showNameInput;
  Function clearFlutterComponents;
  bool forceCancelDropFocus = false;

  clearAll() {
    focusScopeNode.unfocus();
    Flame.util.fullScreen();
    clearFlutterComponents();
  }

  @override
  void render(Canvas canvas) {
    if (screen != null) screen.render(canvas);
  }

  @override
  void update(double t) {
    if (screen != null) screen.update(t);
  }

  @override
  void resize(Size size) {
    if (focusNode == null || !focusNode.hasFocus) {
      this.size = size;
      if (this.screen == null && size.width > size.height)
        screen = HomeScreen(this);
      if (screen != null) screen.resize(size);
    }
  }

  toScreen(Screen screen) {
    this.screen = screen;
  }

  onTapDown(TapDownDetails details) {
    if (screen != null) screen.onTapDown(details);
    if (!forceCancelDropFocus && focusNode != null) {
      focusScopeNode.unfocus();
      focusNode = null;
    }
    forceCancelDropFocus = false;
  }

  onTapUp(TapUpDetails details) {
    if (screen != null) screen.onTapUp(details);
  }

  onVerticalUpdate(DragUpdateDetails details) {
    if (screen != null) screen.onVerticalUpdate(details);
  }

  onVerticalStart(DragStartDetails details) {
    if (screen != null) screen.onVerticalStart(details);
  }

  onVerticalEnd(DragEndDetails details) {
    if (screen != null) screen.onVerticalEnd(details);
  }

  onHorizontalUpdate(DragUpdateDetails details) {
    if (screen != null) screen.onHorizontalUpdate(details);
  }

  onHorizontalStart(DragStartDetails details) {
    if (screen != null) screen.onHorizontalStart(details);
  }

  onHorizontalEnd(DragEndDetails details) {
    if (screen != null) screen.onHorizontalEnd(details);
  }

  flutterWidgetAction() {
    if(screen != null) {
      screen.flutterWidgetAction();
    }
  }
}
