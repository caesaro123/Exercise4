//-----------------------------------------------------------
// Mobile Application Programming (SCSJ3623)
// Semester 2, 2019/2020
// Exercise 4: Back end services - Flutter App
//
// Name 1:  ......
// Name 2:  ......
//-----------------------------------------------------------

// TODO: Modify this file accordingly

import 'package:flutter/material.dart';

import '../models/quote_model.dart';
import '../services/quote_data_service.dart';

class QuoteListScreen extends StatefulWidget {
  @override
  _QuoteListScreenState createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends State<QuoteListScreen> {
  List<Quote> _quotes;
  final dataService = QuoteDataService();

  int starsList(int l, int d) {
    var percentage = (l / (l + d));
    var stars = (5 * percentage).round();

    return stars;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Quote>>(
        future: dataService.getAllQuotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _quotes = snapshot.data;
            return _buildMainScreen();
          }
          return _buildFetchingDataScreen();
        });
  }

  Scaffold _buildMainScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes of the day'),
      ),
      body: ListView.separated(
        itemCount: _quotes.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.blueGrey,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            trailing: _buildThumbButtons(index),
            title: Text(_quotes[index].data,
                textAlign: TextAlign.justify, style: TextStyle(fontSize: 12)),
            subtitle: _buildStarRatings(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),

        // TODO: Define the 'onPressed' callback for the 'Refresh' button
        onPressed: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildStarRatings([int stars = 0]) {
    // stars : how many (full) stars to draw. The remaining star (i.e., 5 - stars) will be drawn as 'bordered star'

    // TODO: You can use two loops in this function
    //          1. To build the list of 'full stars'
    //          2. To build the list of 'bordered or empty stars'
    //
    List<Icon> star = [];

    var numberofstar = 5;

    for (int i = 0; i < numberofstar; i++) {
      if (stars != 0) {
        star.add(
          Icon(
            Icons.star,
            color: Colors.orange,
            size: 15,
          ),
        );
        stars--;
      } else {
        star.add(
          Icon(
            Icons.star_border,
            color: Colors.orange,
            size: 15,
          ),
        );
      }
    }

    return Row(mainAxisSize: MainAxisSize.min, children: star);
  }

  Widget _buildThumbButtons(int index) {
    Quote quote = _quotes[index];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('5', style: TextStyle(color: Colors.green)),
        IconButton(
          icon: Icon(
            Icons.thumb_up,
            color: Colors.green,
          ),
          // TODO: Define the 'onPressed' callback for each 'Thumb up' button
          onPressed: () async {
            Quote updatedQuote =
                await dataService.updateLikes(id: quote.id, like: quote.like++);
            setState(() => quote.like = updatedQuote.like);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.thumb_down,
            color: Colors.red,
          ),
          // TODO: Define the 'onPressed' callback for each 'Thumb down' button
          onPressed: () async {
            Quote updatedQuote = await dataService.updateDislikes(
                id: quote.id, dislike: quote.dislike++);
            setState(() => quote.dislike = updatedQuote.dislike);
          },
        ),
        Text('5', style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Scaffold _buildFetchingDataScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 50),
            Text('Fetching quotes... Please wait'),
          ],
        ),
      ),
    );
  }
}
