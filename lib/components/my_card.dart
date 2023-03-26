import 'package:emergenshare/components/my_card_list_widget.dart';
import 'package:flutter/material.dart';

/*class MyCard extends StatefulWidget {
  final MyCardData data;

  MyCard({required this.data});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.data.title),
            ),
            body: Center(
              child: Hero(
                tag: widget.data.imageUrl,
                child: ScaleTransition(
                  scale: _animation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        widget.data.imageUrl,
                        height: 250.0,
                        width: 250.0,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        widget.data.title,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        widget.data.subtitle,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).then((value) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _animationController.forward();
        _navigateToDetails(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        height: 250.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.0,
              blurRadius: 5.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: widget.data.imageUrl,
                child: Image.network(
                  widget.data.imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.4),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.data.subtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

/*class MyCard extends StatelessWidget {
  final MyCardData data;

  MyCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MyCardDetailsScreen(
              data: data,
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: ModalRoute.of(context)!.animation!,
                  curve: Curves.easeOut,
                ),
              ),
            ),
          ),
        );
      },
      child: Hero(
        tag: data.imageUrl,
        child: Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    data.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      data.subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

class MyCard extends StatefulWidget {
  final MyCardData data;

  MyCard({required this.data});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return MyCardDetailsScreen(
                data: widget.data,
                animation: _createAnimation()
              );
            },
          ),
        );
      },
      child: Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 1.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              child: Image.network(
                widget.data.imageUrl,
                width: 120.0,
                height: 120.0,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.data.subtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createAnimation() {
    return CurvedAnimation(
      parent: ModalRoute.of(context)!.animation!,
      curve: Curves.easeInOut,
    );
  }
}

class MyCardDetailsScreen extends StatefulWidget {
  final MyCardData data;
  final Animation<double> animation;

  MyCardDetailsScreen({required this.data, required this.animation});

  @override
  _MyCardDetailsScreenState createState() => _MyCardDetailsScreenState();
}

class _MyCardDetailsScreenState extends State<MyCardDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image at the top with expand animation
              Container(
                width: MediaQuery.of(context).size.width,
                child: Hero(
                  tag: widget.data.imageUrl,
                  child: Image.network(
                    widget.data.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Padding for text content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AnimatedBuilder(
                  animation: widget.animation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: widget.animation.value,
                      child: Transform.translate(
                        offset: Offset(0.0, 100 * (1 - widget.animation.value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      Text(
                        widget.data.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        widget.data.subtitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        widget.data.longText,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16.0,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Text('Donate'),
                      ),
                      // Disclaimer at the bottom right
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            //TODO
                          },
                          child: Text(
                            'Posted by: ${widget.data.postingEntity.title}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/*
class MyCardDetailsScreen extends StatefulWidget {
  final MyCardData data;
  final Animation<double> animation;

  MyCardDetailsScreen({required this.data, required this.animation});

  @override
  _MyCardDetailsScreenState createState() => _MyCardDetailsScreenState();
}

class _MyCardDetailsScreenState extends State<MyCardDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _imageAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _textAnimation = CurvedAnimation(
      parent: widget.animation,
      curve: Interval(0.4, 1.0, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: widget.data.imageUrl,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ScaleTransition(
                  scale: _imageAnimation,
                  child: Image.network(
                    widget.data.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ScaleTransition(
                scale: _textAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      widget.data.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.data.subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
