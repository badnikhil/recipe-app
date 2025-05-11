import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/global.dart';
import 'package:recipe_app/recipe.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  List<dynamic> searchResults = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged() {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
        searchResults = [];
      });
      fetchSearchResults(searchController.text);
    } else {
      setState(() {
        isLoading = false;
        searchResults = [];
      });
    }
  }

  Future<void> fetchSearchResults(String query) async {
    String url = 'https://www.themealdb.com/api/json/v1/1/search.php?s=$query'; 

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          searchResults = jsonDecode(response.body)['meals'] ?? []; 
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showErrorDialog('Error fetching results.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('Network error: $e');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon:const Icon(Icons.arrow_back_ios),color: const Color.fromARGB(203, 205, 218, 255),),
        backgroundColor: Colors.grey[200],
                title: TextField(
          controller: searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.black54),
            border:OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[350]!,),borderRadius: BorderRadius.circular(10)) ,
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey),borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close, color: Color.fromARGB(203, 205, 218, 255)),
              onPressed: () {
                
              },
            ),
          ),
        ),
      ),
      body: Container(color: Colors.grey[200],
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : searchResults.isEmpty
                ? const Center(child: Text('No results found'))
                : ListView.builder(cacheExtent: 1000,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      
                      return RecipeCard(api: searchNameAPI+searchResults[index]['strMeal'].toString());
                    },
                  ),
      ),
    );
  }
}

