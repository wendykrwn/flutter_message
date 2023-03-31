import 'package:flutter/material.dart';
import 'package:my_app/view/list_favoris.dart';
import 'package:my_app/view/list_message_page.dart';
import 'package:my_app/view/list_personne.dart';
import 'package:my_app/controller/my_drawer.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  //variable
  int currentPage = 0;

  //méthode
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: const MyDrawer(),
      ),
      appBar: AppBar(),
      body: bodyPage(currentPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Listes"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoris"),
        ],
      ),
    );
  }

  Widget bodyPage(int page) {
    switch (page) {
      case 0:
        return const ListPersonne();
      case 1:
        return const ListMessages();
      case 2:
        return const ListFavoris();
      case 4:
        return const Text("Un chat avec un user");
      default:
        return const Text("Mauvaise page");
    }
  }
}
