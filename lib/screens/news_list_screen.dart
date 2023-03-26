import 'package:emergenshare/components/my_card_list_widget.dart';
import 'package:flutter/material.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MyCardListWidget(
        cardDataList: cardDataList,
      ),
    );
  }
}
const Organisation or1 = Organisation(id: "redCross", title: "Red Cross", imageUrl: "Empty");
const Organisation or2 = Organisation(id: "aktionDeutschlandHilft", title: "Aktion Deutschland Hilft", imageUrl: "Empty");

const String longTextSample = """As you know, the world is facing many challenges today, and many people are struggling to make ends meet. It's easy to feel powerless in the face of so much need, but we believe that together, we can make a difference. That's why we're reaching out to you today to ask for your support. Our organization is dedicated to making a positive impact in the lives of those who need it most. We work tirelessly to provide food, shelter, and other essential resources to those who are struggling, and we do so with the help of generous donors like you.""";
const List<MyCardData> cardDataList = [
  MyCardData(
    imageUrl:
        'https://images.pexels.com/photos/207193/pexels-photo-207193.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Combat Hunger',
    subtitle:
        'Help provide food and support for those who suffer from malnutrition and hunger.',
    postingEntity: or1,
    longText: longTextSample,
  ),
  MyCardData(
    imageUrl:
        'https://images.pexels.com/photos/2127895/pexels-photo-2127895.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Support Victims of War',
    subtitle:
        'Help provide aid and assistance to those affected by war and conflict.',
      postingEntity: or1,
    longText: longTextSample,
  ),
  MyCardData(
    imageUrl:
        'https://images.pexels.com/photos/3763335/pexels-photo-3763335.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Relief for Natural Disasters',
    subtitle:
        'Help provide relief and support for those affected by natural disasters like earthquakes, hurricanes, and floods.',
      postingEntity: or1,
    longText: longTextSample,
  ),
  MyCardData(
    imageUrl:
        'https://images.pexels.com/photos/5680009/pexels-photo-5680009.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Emergency Response',
    subtitle:
        'Help provide immediate aid and support for those in crisis situations like fires, floods, or terrorist attacks.',
      postingEntity: or1,
    longText: longTextSample,
  ),
  MyCardData(
    imageUrl:
        'https://images.pexels.com/photos/5690826/pexels-photo-5690826.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Provide Clean Water',
    subtitle:
        'Help provide clean and safe drinking water to those in need in developing countries.',
      postingEntity: or1,
    longText: longTextSample,
  ),
  MyCardData(
    imageUrl:
        'https://images.pexels.com/photos/3758919/pexels-photo-3758919.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Fight Poverty',
    subtitle:
        'Help provide support and resources to lift people out of poverty and improve their quality of life.',
      postingEntity: or2,
    longText: longTextSample,
  ),
  MyCardData(
    imageUrl:
        'https://images.pexels.com/photos/2127895/pexels-photo-2127895.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Promote Education',
    subtitle:
        'Help provide access to education and resources to support learning and development in underprivileged communities.',
      postingEntity: or2,
    longText: longTextSample,
  ),
  MyCardData(
    imageUrl:
        'https://images.pexels.com/photos/207193/pexels-photo-207193.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500',
    title: 'Protect Children',
    subtitle:
        'Help provide support and protection for children who are victims of abuse, exploitation, or neglect.',
      postingEntity: or2,
    longText: longTextSample,
  ),
];


