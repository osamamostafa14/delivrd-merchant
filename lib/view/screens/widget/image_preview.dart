import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String? imageURL;
  ImagePreview({this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(top: 50, right: 25),
                  child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.black)),
                ),
                Image.network(imageURL!),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 80, vertical: 50),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(imageURL!)),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.orange, width: 2)))
              ],
            )));
  }
}
