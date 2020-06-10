import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/screens/lobby/lobby_screen.dart';
import 'package:sudoku/widgets/action_button.dart';

import '../login/login_screen.dart';
import '../sudoku/sudoku_screen.dart';
import '../../models/database.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _handleSignOut(BuildContext context) async {
    await _googleSignIn.signOut();
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).canvasColor,
                splashColor: Colors.black,
                elevation: 0,
                highlightElevation: 0,
                onPressed: () => _handleSignOut(context),
                child: FittedBox(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Create Room',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  TabBar(
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    controller: tabController,
                    tabs: <Widget>[
                      Tab(text: 'Create'),
                      Tab(text: 'Join'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [CreateRoom(), JoinRoom()],
                    ),
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

class CreateRoom extends StatefulWidget {
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final createRoomForm = GlobalKey<FormState>();
  String adminName;

  void createRoom(context) async {
    final db = Provider.of<Database>(context, listen: false);
    await db.createRoom(name: adminName);
    Navigator.of(context).pushReplacementNamed(LobbyScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: createRoomForm,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(labelText: "Your Name"),
              validator: (value) {
                if (value.length == 0) return "Enter your name";
                return null;
              },
              onSaved: (value) {
                adminName = value;
              },
            ),
            SizedBox(height: 10),
            ActionButton(
              onPressed: () => createRoom(context),
              text: 'Create Room',
            ),
          ],
        ),
      ),
    );
  }
}

class JoinRoom extends StatefulWidget {
  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  var joinRoomForm = GlobalKey<FormState>();
  String userName;
  int roomCode;
  FocusNode nameNode;

  @override
  void initState() {
    super.initState();
    nameNode = FocusNode();
  }

  void joinRoom(context) async {
    if (!joinRoomForm.currentState.validate()) return;

    joinRoomForm.currentState.save();
    final db = Provider.of<Database>(context, listen: false);
    final joined = await db.joinRoom(name: userName, roomCode: roomCode);

    if (joined)
      Navigator.of(context).pushReplacementNamed(SudokuScreen.routeName);
    else
      showAlert(context, 'The room is already full.');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: joinRoomForm,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Room Code",
              ),
              validator: (value) {
                if (value.length == 0) return "Enter room code";
                var parsedRoomCode = int.tryParse(value);
                if (parsedRoomCode == null) return "Room code must be a number";
                return null;
              },
              onSaved: (value) {
                roomCode = int.parse(value);
              },
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => nameNode.requestFocus(),
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Your Name",
              ),
              focusNode: nameNode,
              validator: (value) {
                if (value.length == 0) return "Enter your name";
                return null;
              },
              onSaved: (value) {
                userName = value;
              },
            ),
            SizedBox(height: 10),
            ActionButton(
              onPressed: () => joinRoom(context),
              text: 'Join Room',
            )
          ],
        ),
      ),
    );
  }
}

void showAlert(BuildContext context, String s) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Error"),
      content: Text(
        s,
        style: TextStyle(color: Colors.black),
      ),
    ),
  );
}
