import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/firebase_services.dart';
import 'package:http/http.dart' as http;

import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeCard extends StatefulWidget {
 final String api;
   const RecipeCard({super.key,required this.api});
   
  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isLoading=true;
   bool isLiked=false;
 
  List<dynamic> data=[];

  Future<void> fetch() async {
    final response =await http.get(Uri.parse(widget.api));
          if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          data = jsonDecode(response.body)['meals'];
        
        
        });
      }
        //  

if(mounted) {
  isLiked= await FirebaseServices().isRecipeLiked(data[0]['idMeal']);
  if(mounted) {
    setState(() {
  isLoading=false;
});
  }
} 


    } else {
     throw Exception('CH');
    }

   
  }
@override
  void initState(){
    
    super.initState();
     fetch();

  }
  @override
  Widget build(BuildContext context) {
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
            ):
    Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.grey[100]),
          margin: const EdgeInsets.only(left: 15, right: 15),
          padding: const EdgeInsets.all(5),
          height: 110,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  data[0]['strMealThumb'].toString(),
                  width: 110,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data[0]['strCategory'].toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'font1',
                          color: Color.fromRGBO(9, 194, 241, 1),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        data[0]['strMeal'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'font1',
                          color: Colors.black87,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.tag, size: 20),
                          Expanded(
                            child: Text(
                              (data[0]['strTags'] == null ||
                                      data[0]['strTags'] ==
                                          'null')
                                  ? '  NO TAGS'
                                  : '  ${data[0]['strTags']
                                      .toString()
                                      .split(',')
                                      .join(', ')} ',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
           
            ],
          ),
        ),
      
      SizedBox(width: double.maxFinite-50,height: 120,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,shadowColor: Colors.transparent),
          onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) =>  RecipeDetails(data:data)));
         
        }, child: null),
      ),

         Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,
           children: [
             Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          FirebaseServices().toggleLike(data[0]['idMeal'].toString());
                          isLiked=!isLiked;
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
                    ),
                  ),
           ],
         ),],
      
    );
  }
}










class RecipeDetails extends StatefulWidget {
  final List<dynamic> data;
  const RecipeDetails({super.key,required this.data});

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {



  void fetch()async{
     bool liked=await FirebaseServices().isRecipeLiked(mealID);
    setState(() {
      isliked=liked;
    });
  }
late String mealID;


  bool isliked=false;
  String selSec="";


  List<String> section=['Recipe','Ingredients','Video'];


@override
  void initState() {
  
    super.initState();
    selSec=section[0];
    mealID=widget.data[0]['idMeal'].toString();
    fetch();
  
 

  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor:  const Color.fromARGB(255, 235 , 227, 224),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(padding: const EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  height: 250,  
                 width: double.maxFinite,
                  child: Image.network(
                    widget.data[0]['strMealThumb'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              
                Positioned(
                  right: 20,
                  top: 200,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isliked = !isliked;
                        FirebaseServices().toggleLike(mealID);
                      });
                    },
                    icon: (isliked)
                        ? const Icon(Icons.favorite, color: Color(0xFFFF6F61))
                        : const Icon(Icons.favorite_border_outlined),
                    iconSize: 35,
                  ),
                ),
              IconButton(onPressed: (){
                setState(() {
                  Navigator.pop(context);
                });
              }
           
              , icon: const Icon(Icons.arrow_back_ios_rounded,color: Colors.black,),)
              ],
              
            ),
           
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.tag, size: 30, color: Colors.grey),
                  const SizedBox(width: 8),
                  // Display tags from tempdata['strtags']
                  Flexible(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: widget.data[0]['strTags']?.split(',')?.map<Widget>((tag) {
                        return Chip(shape:RoundedRectangleBorder(side: const BorderSide(color:Colors.transparent ),borderRadius: BorderRadius.circular(17)),
                          label: Text(tag.trim()),
                          backgroundColor: Colors.white,
                          
                        );
                      })?.toList() ??
                          [],
                    ),
                  ),
                ],
              ),
            ),






            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(25)),padding: const EdgeInsets.symmetric(horizontal: 25),margin: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        widget.data[0]['strMeal'].toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontFamily: 'font1',
                          color: Color(0xFF333333),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: section.map((e) {
                final isActive = e == selSec;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selSec = e;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 22),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isActive
                          ? const Color(0xFF9ACD32)
                          : const Color(0xFFFDF5E6),
                    ),
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
           if(selSec=='Recipe')RecipeSection(data: widget.data),
           if(selSec=='Ingredients')
              IngredientsSection(data: widget.data)  ,
        if(selSec=='Video')VideoSection(data: widget.data),        
    
         

          ],
        ),
      ),
    );
}

}

class VideoSection extends StatefulWidget {
  final List<dynamic> data;
  const VideoSection({super.key, required this.data});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    // Extract the YouTube video ID from the URL
    String videoId = _extractVideoId(widget.data[0]['strYoutube'].toString());

    // Initialize the YouTube Player Controller
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: MediaQuery.of(context).size.width,
          height: 250.0,
          color: Colors.amber,
          child: YoutubePlayer(
            controller: _youtubeController,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
            onReady: () {
              debugPrint('YouTube Player is ready.');
            },
          ),
        ),
      ],
    );
  }


  String _extractVideoId(String url) {
    final regExp = RegExp(
      r'(?:v=|\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    return match != null ? match.group(1)! : 'dQw4w9WgXcQ';
  }
}


class IngredientsSection extends StatefulWidget {
  final  List<dynamic> data;
  const IngredientsSection({super.key,required this.data});

  @override
  State<IngredientsSection> createState() => _IngredientsSectionState();
}

class _IngredientsSectionState extends State<IngredientsSection> {

late List<Map<String, String>> ingredients;
List<Map<String, String>> filterIngredients(Map<String, dynamic> recipeData) {
  List<Map<String, String>> ingredients = [];

  for (int i = 1; i <= 20; i++) {
   
    String? ingredient = recipeData['strIngredient$i'];
    String? measure = recipeData['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
      ingredients.add({
        "ingredient": ingredient,
        "measure": measure ?? "",
      });
    }
  } 
  return ingredients;

}
String capitalize(String text) {
  if (text.isEmpty) {
    return text;
  } else {
    return text[0].toUpperCase() + text.substring(1);
  }
}

@override
  void initState() {

    super.initState();
     ingredients = filterIngredients(widget.data[0]);
    
  }

   @override
  Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(color: const Color.fromARGB(255, 235 , 227, 224),borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingredients:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
           
            ListView.builder(
              itemCount: ingredients.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom:10.0),
                  child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),padding: const EdgeInsets.all(10),
                            
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1.3),
                          child: Text(
                            '${index + 1}. ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 20
                            ),

                          ),
                        ),
                        Expanded(child: Text( '${capitalize(ingredients[index]["ingredient"].toString())} (${ingredients[index]["measure"]})',
                        style: 
                        const TextStyle(fontFamily: 'font1',fontSize: 20),))
                       
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
  }
}


class RecipeSection extends StatefulWidget {
  final  List<dynamic> data;
  const RecipeSection({super.key,required this.data});


  @override
  State<RecipeSection> createState() => _RecipeSectionState();
}

class _RecipeSectionState extends State<RecipeSection> {

List<String> steps=[];
List<String> parseSteps(String instructions) {
  
  List<String> steps = instructions.split('.').map((step) => step.trim()).toList();

 
  steps.removeWhere((step) => step.isEmpty);
 
  return steps;
}

@override
  void initState() {
    super.initState();
    steps=parseSteps(widget.data[0]['strInstructions']);
  }


  @override
  Widget build(BuildContext context) {
      return  Container(decoration: BoxDecoration(color: const Color.fromARGB(255, 235 , 227, 224),borderRadius: BorderRadius.circular(15)),
        child: Padding(
                  padding: const EdgeInsets.only(top: 10,left: 10,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recipe Steps:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                     
                      ListView.builder(
                        itemCount: steps.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 01.6),
                                    child: Text(
                                      '${index + 1}.  ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,fontFamily: 'font1'
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      steps[index],
                                      style: const TextStyle(fontSize: 15,fontFamily: 'font1'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
      );
  }
}

