import 'package:emergenshare/components/my_card_list_widget.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final controller = DragSelectGridViewController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scheduleRebuild);
  }

  @override
  void dispose() {
    controller.removeListener(scheduleRebuild);
    super.dispose();
  }

  void scheduleRebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SelectionAppBar(//AppBar(
        title: Text('Select Organisations'),
      ),
      body: DragSelectGridView(
        gridController: controller,
        itemCount: cardDataList.length,
        itemBuilder: (context, index, isSelected) {
          return SelectableItem(
            color: Colors.blueGrey,
          index: index,
          selected: isSelected);},
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        padding: const EdgeInsets.all(4.0),
      ),
    );
  }
}
class SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SelectionAppBar({
    Key? key,
    this.title,
    this.selection = const Selection.empty(),
  }) : super(key: key);

  final Widget? title;
  final Selection selection;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: selection.isSelecting
          ? AppBar(
        key: const Key('selecting'),
        titleSpacing: 0,
        leading: const CloseButton(),
        title: Text('${selection.amount} item(s) selected…'),
      )
          : AppBar(
        key: const Key('not-selecting'),
        title: title,
      ),
    );
  }
}

class SelectableItem extends StatefulWidget {
  const SelectableItem({
    Key? key,
    required this.index,
    required this.color,
    required this.selected,
  }) : super(key: key);

  final int index;
  final MaterialColor color;
  final bool selected;

  @override
  _SelectableItemState createState() => _SelectableItemState();
}

class _SelectableItemState extends State<SelectableItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: widget.selected ? 1 : 0,
      duration: kThemeChangeDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void didUpdateWidget(SelectableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Container(
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: ChangedCard(data: cardDataList[widget.index],) /*Container(
        alignment: Alignment.center,
        child: Text(
          'Item\n#${widget.index}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),*/
    );
  }

  Color? calculateColor() {
    return Color.lerp(
      widget.color.shade500,
      widget.color.shade900,
      _controller.value,
    );
  }
}

class ChangedCard extends StatefulWidget {
  final Organisation data;
  ChangedCard({required this.data});
  @override
  _ChangedCardState createState() => _ChangedCardState();
}
class _ChangedCardState extends State<ChangedCard> with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        //margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const List<Organisation> cardDataList = [
  Organisation(
    id: "zeb",
    imageUrl: 'https://images.pexels.com/photos/207193/pexels-photo-207193.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Zebra help',
    subtitle: 'Help provide food and support for those who suffer from malnutrition and hunger.',
  ),
  Organisation(
    id: "car",
    imageUrl: 'https://images.pexels.com/photos/2127895/pexels-photo-2127895.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Car accident victims',
    subtitle: 'Help provide aid and assistance to those affected by war and conflict.',
  ),
  Organisation(
    id: "des",
    imageUrl: 'https://images.pexels.com/photos/3763335/pexels-photo-3763335.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Fashion disasters',
    subtitle: 'Help provide relief and support for those affected by natural disasters like earthquakes, hurricanes, and floods.',
  ),
  Organisation(
    id: "bnk",
    imageUrl: 'https://images.pexels.com/photos/5680009/pexels-photo-5680009.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Banks for students',
    subtitle: 'Help provide immediate aid and support for those in crisis situations like fires, floods, or terrorist attacks.',
  ),
  Organisation(
    id: "ger",
    imageUrl: 'https://images.pexels.com/photos/5690826/pexels-photo-5690826.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'German Fire Help',
    subtitle: 'Help provide clean and safe drinking water to those in need in developing countries.',
  ),
  Organisation(
    id: "onoe",
    imageUrl: 'https://images.pexels.com/photos/3758919/pexels-photo-3758919.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Phone donations',
    subtitle: 'Help provide support and resources to lift people out of poverty and improve their quality of life.',
  ),
  Organisation(
    id: "redlight",
    imageUrl: 'https://images.pexels.com/photos/2127895/pexels-photo-2127895.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Red light donations',
    subtitle: 'Help provide access to education and resources to support learning and development in underprivileged communities.',
  ),
  Organisation(
    id: "madagascar",
    imageUrl: 'https://images.pexels.com/photos/207193/pexels-photo-207193.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Madagascar 5',
    subtitle: 'Help provide support and protection for children who are victims of abuse, exploitation, or neglect.',
  ),
];