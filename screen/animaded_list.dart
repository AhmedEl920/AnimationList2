import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimadedListScreen extends StatefulWidget {
  const AnimadedListScreen({super.key});

  @override
  State<AnimadedListScreen> createState() => _AnimadedListScreenState();
}

class _AnimadedListScreenState extends State<AnimadedListScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Animated List",
        ),
        centerTitle: true,
        leading: Container(),
        elevation: 0,
      ),
      body: CustomAnimationList(),
    );
  }
}

class CustomAnimationList extends StatefulWidget {
  @override
  State<CustomAnimationList> createState() => _CustomAnimationListState();
}

class _CustomAnimationListState extends State<CustomAnimationList> {
  final List<String> items = [];

  final GlobalKey<AnimatedListState> key = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 50,
        width: double.infinity,
        color: Color.fromARGB(255, 224, 129, 241),
        child: IconButton(
          onPressed: insertItem,
          icon: Icon(
            Icons.add,
          ),
        ),
      ),
      Expanded(
        child: AnimatedList(
            key: key,
            controller: scrollController,
            initialItemCount: items.length,
            itemBuilder: (context, index, Animation) {
              return SizeTransition(
                  sizeFactor: Animation,
                  child: AnimatedListItem(
                      onpressed: () {
                        deleteItem(index);
                      },
                      text: items[index]));
            }),
      ),
    ]);
  }

  void insertItem() {
    var index = items.length;
    items.add(
      'item${index + 1}',
    );

    key.currentState!.insertItem(index);
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void deleteItem(int index) {
    var removedItem = items.removeAt(index);
    key.currentState!.removeItem(index, (context, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: AnimatedListItem(
          text: removedItem,
          onpressed: () {},
        ),
      );
    });
  }
}

class AnimatedListItem extends StatelessWidget {
  AnimatedListItem({this.text, required this.onpressed});
  String? text;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      elevation: 10,
      color: Color.fromARGB(255, 200, 65, 234),
      child: ListTile(
        title: Text(text!, style: TextStyle(color: Colors.white)),
        trailing: IconButton(
          onPressed: onpressed,
          icon: Icon(Icons.delete),
        ),
      ),
    );
  }
}
