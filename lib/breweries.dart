import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:versa_test/fav_page.dart';

import 'map_page.dart';
import 'provider.dart';

class BreweriesPage extends StatelessWidget {
  BreweriesPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final breweriesLists = Provider.of<BreweriesListsProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FavouritePage()));
            },
            leading: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            title: const Text("Favourite"),
          ),
        ],
      )),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () {
                     _scaffoldKey.currentState!.openDrawer();
                  },
                ),
                const SizedBox(width: 20),
                const Text(
                  "Breweries List",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: breweriesLists.getBreweriesListFromServer(1),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Consumer<BreweriesListsProvider>(builder: (context, value, __) {
                    return BreweriesLists(breweriesLists: value.getBreweriesLists(), provider: breweriesLists);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreweriesLists extends StatefulWidget {
  final List breweriesLists;
  final BreweriesListsProvider provider;
  const BreweriesLists({Key? key, required this.breweriesLists, required this.provider}) : super(key: key);

  @override
  _BreweriesListsState createState() => _BreweriesListsState();
}

class _BreweriesListsState extends State<BreweriesLists> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        widget.provider.getBreweriesListFromServer(page++);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.breweriesLists.length + 1,
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == widget.breweriesLists.length) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(15.0),
            child: CircularProgressIndicator(),
          ));
        }
        return BreweryListTile(
          brewery: widget.breweriesLists[index],
          index: index,
          provider: widget.provider,
        );
      },
    );
  }
}

class BreweryListTile extends StatefulWidget {
  final Map brewery;
  final int index;
  final BreweriesListsProvider provider;
  const BreweryListTile({Key? key, required this.brewery, required this.index, required this.provider}) : super(key: key);

  @override
  _BreweryListTileState createState() => _BreweryListTileState();
}

class _BreweryListTileState extends State<BreweryListTile> {
  @override
  Widget build(BuildContext context) {
    bool isPressed = widget.provider.checkFavContainBrewery(widget.index);

    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MapPage(
                      brewery: widget.brewery,
                    )));
      },
      title: Text(
        "${widget.brewery["name"]} (${widget.brewery["brewery_type"]})",
      ),
      subtitle: Text(widget.brewery["city"]),
      trailing: IconButton(
        icon: isPressed ? const Icon(Icons.favorite) : const Icon(Icons.favorite_outline),
        onPressed: () {
          setState(() {
            isPressed = !isPressed;
            if (isPressed) {
              Provider.of<BreweriesListsProvider>(context, listen: false).addFavBreweriesLists(widget.brewery);
            } else {
              Provider.of<BreweriesListsProvider>(context, listen: false).removeFavBreweriesLists(widget.brewery);
            }
          });
        },
        color: Colors.red,
      ),
    );
  }
}
