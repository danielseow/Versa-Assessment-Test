import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final breweriesListsProvider = Provider.of<BreweriesListsProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 20),
                const Text(
                  "Favourite List",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Consumer<BreweriesListsProvider>(builder: (context, value, __) {
                return ListView.builder(
                  itemCount: breweriesListsProvider.getFavBreweriesLists().length,
                  itemBuilder: (context, index) {
                    // log(breweriesListsProvider.getFavBreweriesLists().toString());
            
                    return ListTile(
                      title: Text(
                        "${value.getFavBreweriesLists()[index]["name"]} (${value.getFavBreweriesLists()[index]["brewery_type"]})",
                      ),
                      subtitle: Text(value.getFavBreweriesLists()[index]["city"]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () {
                          breweriesListsProvider.removeFavBreweriesLists(value.getFavBreweriesLists()[index]);
                        },
                        color: Colors.red,
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
