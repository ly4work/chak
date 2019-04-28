import 'package:flutter/material.dart';

import 'dog_model.dart';
import 'pages/dog_detail_page.dart';

class DogCard extends StatefulWidget {
  final Dog dog;
  DogCard(this.dog);

  @override
  _DogCardState createState() => _DogCardState(dog);
}

class _DogCardState extends State<DogCard> {
  Dog dog;
  String renderUrl;

  _DogCardState(this.dog);

  void initState() {
    super.initState();
    renderDogPic();
  }

  void renderDogPic() async {
    await dog.getImageUrl();
    setState(() {
      renderUrl = dog.imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showDogDetailPage,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            height: 115.0,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 70.0,
                  child: dogCard,
                ),
                Positioned(
                  left: 20.0,
                  top: 7.5,
                  child: dogImage,
                )
              ],
            ),
          )),
    );
  }

  Widget get dogImage {
    var dogAvatar = Hero(
      tag: dog,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(renderUrl ?? ''))),
      ),
    );
    var placeholder = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black54, Colors.black, Colors.blueGrey[600]])),
      alignment: Alignment.center,
      child: Text(
        'DOGGO',
        textAlign: TextAlign.center,
      ),
    );
    return AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: dogAvatar,
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 1000),
    );
  }

  Widget get dogCard {
    return Container(
      width: 290.0,
      height: 120.0,
      child: Card(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 64.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                widget.dog.name,
                style: Theme.of(context).textTheme.headline,
              ),
              Text(
                widget.dog.location,
                style: Theme.of(context).textTheme.subhead,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.star),
                  Text(':${widget.dog.rating} / 10')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showDogDetailPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return DogDetailPage(dog);
    }));
  }
}
