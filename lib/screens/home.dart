import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wanna_hyke/models/hike.dart';
import 'package:wanna_hyke/services/auth.dart';
import 'package:wanna_hyke/services/database.dart';
import 'package:wanna_hyke/widgets/hike_card.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const Home({Key key, this.auth, this.firestore}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _hykeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wanna Hyke"),
        centerTitle: true,
        actions: [
          IconButton(
            key: const ValueKey("signOut"),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Auth(auth: widget.auth).signOut();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.auth.currentUser.displayName),
              accountEmail: Text(widget.auth.currentUser.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.black,
                //TODO: Change this to user avatar and add placeholder for null images
                backgroundImage: NetworkImage("https://via.placeholder.com/150"),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('New Hike'),
            ),
            const ListTile(
              leading: Icon(Icons.assignment),
              title: Text('View Hikes'),
            ),
            const ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Request New Mountain'),
            ),
            const ListTile(
              leading: Icon(Icons.assignment),
              title: Text('View Mountains'),
            ),
          ],
        )
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Add Hike Here:",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const ValueKey("addField"),
                      controller: _hykeController,
                    ),
                  ),
                  IconButton(
                    key: const ValueKey("addButton"),
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_hykeController.text != "") {
                        setState(() {
                          Database(firestore: widget.firestore).addHike(
                              uid: widget.auth.currentUser.uid,
                              mountainId: _hykeController.text);
                          _hykeController.clear();
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Your Hikes",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Database(firestore: widget.firestore)
                  .streamHikes(uid: widget.auth.currentUser.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<List<HikeModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data.isEmpty) {
                    return const Center(
                      child: Text("You don't have any hikes."),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return HikeCard(
                        firestore: widget.firestore,
                        uid: widget.auth.currentUser.uid,
                        hike: snapshot.data[index],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("loading..."),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}