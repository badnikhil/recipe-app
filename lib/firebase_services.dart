

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/global.dart';

class FirebaseServices {

 FirebaseFirestore firestore = FirebaseFirestore.instance;
void createUserDocument(String userID)async{
  try {
      
    DocumentSnapshot userDoc = await firestore.collection('userData').doc(userID.toString()).get();

    if (userDoc.exists) {
    } else {
     
      Map<String, dynamic> userData = {
        'liked': [], 
        
      };

      
      await firestore.collection('userData').doc(userID.toString()).set(userData);

    }
  } catch (e) {
   return null;
  }
}

Future<bool> isRecipeLiked(String recipeId) async {

 
  try {
  
    DocumentSnapshot userSnapshot = await firestore.collection('userData').doc(userID.toString()).get();

    if (userSnapshot.exists) {
   
      List<dynamic> likedRecipes = userSnapshot['liked'] ?? [];

     
      return likedRecipes.contains(recipeId);
    }

   
    return false;
  } catch (e) {
    return false;
  }
}



void toggleLike( String mealID) async {
  
   
  DocumentSnapshot userDoc = await firestore.collection('userData')
      .doc(userID.toString())
      .get();

  if (userDoc.exists) {
   
    List<dynamic> likedArray = userDoc['liked'] ?? [];

 
    if (likedArray.contains(mealID)) {
    
      FirebaseFirestore.instance
          .collection('userData')
          .doc(userID.toString())
          .update({
            'liked': FieldValue.arrayRemove([mealID]), 
          })
          .then((_) {
          })
          .catchError((error) {
          });
    } else {
    
      FirebaseFirestore.instance
          .collection('userData')
          .doc(userID.toString())
          .update({
            'liked': FieldValue.arrayUnion([mealID]), 
          })
          .then((_) {
          })
          .catchError((error) {
          });
    }
  } else {
  }
}


Future<List<int>> getLikedRecipeIds() async {
  try {
  
    DocumentSnapshot userDoc = await firestore
        .collection('userData')
        .doc(userID.toString())
        .get();

    if (userDoc.exists) {
     
      List<dynamic> likedArray = userDoc['liked'] ?? [];

     
      List<int> likedRecipeIds = likedArray.map((id) => int.tryParse(id.toString()) ?? 0).toList();

   
      likedRecipeIds.removeWhere((id) => id == 0);

      return likedRecipeIds;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}



}