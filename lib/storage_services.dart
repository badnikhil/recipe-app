
import 'package:recipe_app/global.dart';
import 'package:recipe_app/main.dart';



class SecureStorageServices {
  Future<void> storeUserID(String userID) async {
    await storage.write(key: 'UserID', value: userID);
  }


  Future<void> getUserID() async {
   userID= await storage.read(key: 'UserID') ;
  }

 
  Future<void> clearUserID() async {
    await storage.delete(key: 'UserID');

  }
}

