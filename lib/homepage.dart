import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app/category.dart';
import 'package:http/http.dart' as http;

import 'package:recipe_app/firebase_services.dart';
import 'package:recipe_app/global.dart';
import 'package:recipe_app/liked_section.dart';

import 'package:recipe_app/recipe.dart';
import 'package:recipe_app/search_screen.dart';
import 'package:recipe_app/signin_page.dart';
import 'package:recipe_app/storage_services.dart';

import 'package:shimmer/shimmer.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isLiked=false;
  bool loading = true;
  List<dynamic> data=[];

  Future<void> fetch() async {
    final response = await http.get(Uri.parse(randomCardAPI));

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          data = jsonDecode(response.body)['meals'];
         
        
        });
      }
    } else {
     throw Exception('CH');
    }
isLiked=await FirebaseServices().isRecipeLiked(data[0]['idMeal'].toString());
setState(() {
  
  loading=false;
});



  }

 void updateuid(){
   SecureStorageServices().getUserID();
  }
    
  @override
void initState() {
    super.initState();
    fetch();  
    updateuid();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(drawer: Drawer(width: MediaQuery.of(context).size.width/2,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.end,
          children: [const Divider(),
           TextButton(
            onPressed: (){

                   SecureStorageServices().clearUserID();
                 
                       Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
           }, child:  Row(
             children: [
               const Text('LOGOUT',style: TextStyle(fontSize: 20),),const Spacer(),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: IconButton(icon:const Icon(( Icons.power_settings_new_outlined)),
                 onPressed:() {
                   SecureStorageServices().clearUserID();
                 
                       Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
                 }
               ))
             ],
           )),
           const Divider(),
          
          ],
        ),
      ),
      
    ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                      
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Color.fromARGB(203, 205, 218, 255),
                        ),
                      );
                    }
                  ),
                ),
                const Spacer(),
               
                 
                   IconButton(
                      onPressed: () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => const LikedSection()), 
    );
                         
                      },
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Color.fromARGB(203, 205, 218, 255),
                      ),
                    ),
                  
                
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    onPressed: () {
                        Navigator.push(context,  MaterialPageRoute(builder: (context) => const SearchScreen())); 
        
                    },
                    icon: const Icon(
                      Icons.search_sharp,
                      color: Color.fromARGB(203, 205, 218, 255),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "DISCOVER",
                style: TextStyle(
                  color: Color.fromARGB(255, 24, 42, 72),
                  fontFamily: 'font',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            if (loading)
              SizedBox(
                height: 250,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 20,
                          margin: const EdgeInsets.only(top: 10),
                          decoration: const BoxDecoration(color: Colors.amber),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                      
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              data[0]['strMealThumb'].toString(),
                              fit: BoxFit.fill
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               
                                const SizedBox(height: 180),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                          Navigator.push(context,MaterialPageRoute(builder: (context) =>  RecipeDetails(data:data)));
         
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                      ),
                                      child: const Text(
                                        'CHECK RECIPE >>',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'font1',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                            FirebaseServices().toggleLike(data[0]['idMeal']);
        
                                          isLiked = !isLiked;
                                        });
                                      },
                                      icon: (isLiked)
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite_border_rounded,
                                            ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'CATEGORIES',
                style: TextStyle(
                  fontFamily: 'font',
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            const CategoryList(),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "EXPLORE",
                style: TextStyle(
                  color: Color.fromARGB(255, 24, 42, 72),
                  fontFamily: 'font',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          SizedBox(height: 145*objects.toDouble(),
            child: ListView.builder(scrollDirection: Axis.vertical,physics: const NeverScrollableScrollPhysics(),
              itemCount:objects,cacheExtent: 100000,
              
              itemBuilder: (context,index,){
                return  Padding(
                    padding: const EdgeInsets.only(left: 5,top:  8.0,bottom: 8,right: 5),
                    child: RecipeCard(api: randomCardAPI,),
                  );
            
                
              }),
          ),
            TextButton(onPressed: (){
            setState(() {
              objects=objects+5;
            });
          }, child: const Center(child: Text('Tap to Load More')))
          
          ],
        ),
      ),
    );
  }
}
