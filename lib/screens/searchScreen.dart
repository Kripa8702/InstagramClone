import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search for an user',
            filled: true,
            fillColor: mobileSearchColor,
            prefixIcon: Icon(
              Icons.search,
              color: primaryColor,
            ),
            contentPadding: const EdgeInsets.all(3),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: mobileSearchColor), //<-- SEE HERE
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: mobileSearchColor), //<-- SEE HERE
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
      body: isShowUsers?
      FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: searchController.text)
        .get(),

        builder: (context, snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (contetx, index){
              return Container(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage:
                    NetworkImage((snapshot.data! as dynamic).docs[index]['photoUrl']),
                  ),
                  title: Text(
                    (snapshot.data! as dynamic).docs[index]['username'],
                  ),
                ),
              );
            },

          );
        },
      ) 
          :FutureBuilder(
        future: FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished')
        .get(),

        builder: (context,snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(
            margin: EdgeInsets.only(top:5),
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 3,
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => Image.network(
                (snapshot.data! as dynamic).docs[index]['postUrl'],
                fit: BoxFit.cover,
              ),

              staggeredTileBuilder: (index) => StaggeredTile.count(
                  (index%7==0)? 2:1,
                  (index%7==0)? 2:1,
              ),
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 3.0,
            ),
          );
        },
      )
    );
  }
}
