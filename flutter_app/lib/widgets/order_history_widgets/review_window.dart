// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../data_fetching_api_calls/review_api_call/add_rating_api.dart';
import '../../data_fetching_api_calls/review_api_call/add_review_api.dart';

import '../../utils/auth/constants.dart';

//a ModalBottomSheet for Review Window
//Has options for adding/editing of Rating & Review
class ReviewWindow extends StatefulWidget {
  BuildContext context;
  String itemSkuId;
  String image;
  String name;
  int price;

  ReviewWindow(
      {required this.context,
      required this.itemSkuId,
      required this.image,
      required this.name,
      required this.price});

  @override
  State<ReviewWindow> createState() => _ReviewWindowState();
}

class _ReviewWindowState extends State<ReviewWindow> {
  double ratingSet = 1.0;

  String review = "";

  Future<void> getRatingReview() async {
    var addReviewApiCallProvider =
        Provider.of<AddReviewAPI>(widget.context, listen: false);

    var addRatingApiCallProvider =
        Provider.of<AddRatingAPI>(widget.context, listen: false);

    addRatingApiCallProvider
        .addRatingAPICall(widget.itemSkuId, ratingSet, widget.itemSkuId)
        .then((value) {
      if (value == true) {
        addReviewApiCallProvider
            .addReviewAPICall(widget.itemSkuId, review, widget.itemSkuId)
            .then((value) {
          if (value == true) {
            Navigator.of(widget.context).pop();
            showDialog(
                context: widget.context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text("Rating and Review added!"),
                  );
                });
          }
        }).catchError((error) {
          Navigator.of(widget.context).pop();
          showDialog(
              context: widget.context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text(error.message),
                );
              });
        });
      }
    }).catchError((error) {
      Navigator.of(widget.context).pop();
      showDialog(
          context: widget.context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(error.message),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: 0,
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                leading: Image.network(widget.image),
                title: Text(
                  widget.name,
                  style: TextStyle(fontSize: 23),
                ),
                trailing: Text(
                  widget.price.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Text("Rating"),
            //Utilized RatingBar package
            RatingBar.builder(
              initialRating: 1,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (ratingValue) {
                ratingSet = ratingValue;
              },
            ),
            Text("Review"),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    review = value;
                  },
                  maxLines: 8,
                  style: TextStyle(
                    fontSize: 15.0,
                    height: 2.0,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    labelStyle: kInputLabelStyle,
                    alignLabelWithHint: true,
                    counterText: '100 Chars. Limit',
                    labelText: 'Write Your Review Here',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              height: 250,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Submit Review',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.left,
              ),
              color: Theme.of(context).colorScheme.tertiary,
              onPressed: () async {
                await getRatingReview();
              },
            ),
          ],
        ),
      ),
    );
  }
}
