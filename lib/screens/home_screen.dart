import 'package:flutter/material.dart';

import 'package:getx_project/screens/show_all_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // CollectionReference userReference =
  //     FirebaseFirestore.instance.collection("users");
  // User? user = FirebaseAuth.instance.currentUser;
  // Future<UserModelFireBase> getdata() async {
  //   DocumentSnapshot ref = await userReference.doc(user?.uid ?? "").get();
  //   UserModelFireBase data = UserModelFireBase.fromDocumentSnapshot(ref);
  //   return data;
  // }

  @override
  Widget build(BuildContext context) {
    return
        //  FutureBuilder<UserModelFireBase>(
        //     future: getdata(),
        //     builder:
        //         (BuildContext context, AsyncSnapshot<UserModelFireBase> snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Scaffold();
        //       }

        //       if (snapshot.connectionState == ConnectionState.done) {
        //         return
        //
        Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Expanded(child: AllPostScreen())],
            ));
  }
}
