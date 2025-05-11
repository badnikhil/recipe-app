import 'package:flutter/material.dart';
import 'package:recipe_app/firebase_services.dart';
import 'package:recipe_app/global.dart';
import 'package:recipe_app/recipe.dart';
import 'package:shimmer/shimmer.dart';

class LikedSection extends StatefulWidget {
  const LikedSection({super.key});

  @override
  State<LikedSection> createState() => _LikedSectionState();
}

class _LikedSectionState extends State<LikedSection> {
 bool isLoading=true;
 int objects=10;
   List<int> likedIDs=[];
  void fetch()async{
    List<int> temp= await FirebaseServices().getLikedRecipeIds();
    setState(() {
      likedIDs=temp;
      isLoading=false;
objects=likedIDs.length;
      
    });

  }

@override
  void initState() {
   
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('LIKED RECIPES'),),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(scrollDirection: Axis.vertical,
              itemCount: objects,cacheExtent: 1000,
              itemBuilder: (context,index){

                  return isLoading?SizedBox(height: 150,
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.only(left:20.0,right: 20),
                      child: Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(
                        height: 10,margin: const EdgeInsets.only(top: 10),decoration: const BoxDecoration(color: Colors.white),
                      )),
                    );
                  }),
              ):Padding(
                padding: const EdgeInsets.all(8.0),
                child: RecipeCard(api: searchIDAPI+likedIDs[index].toString()),
              );
            }),
          )
        ],
      ),
    ) ;
  }
}