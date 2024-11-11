import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../entities/ForumUser.dart';
import '../entities/Topic.dart';
import '../entities/TopicCategory.dart';
import '../entities/user.dart';
import 'elements/category_element.dart';

import 'topics_list.dart';

class CategoriesListView extends StatefulWidget {


  CategoriesListView({
    Key? key,
  }) : super(key: key);


  @override
  _CategoriesListViewState createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  List<TopicCategory> categories = [];
  List<TopicCategory> filteredCategories = [];
  TextEditingController searchController = TextEditingController();
  late bool isAdmin=false;
  late User user;

  Future<void> loadUserData() async {
    try {
      user = (await User.claimCurrentUser())!; // Await the Future
      isAdmin = user.role == "admin";
    } catch (error) {
      print('Error retrieving user: $error');
    }
  }
  @override
  void initState() {
    super.initState();
    loadUserData();
    _fetchCategories();
  }

  // Fetch categories from the API
  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.42:9090/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> categoryList = json.decode(response.body);
        setState(() {
          categories = categoryList.map((json) => TopicCategory.fromJson(json)).toList();
          filteredCategories = categories;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = categories
          .where((category) => category.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum Categories'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search categories',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onChanged: filterCategories,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => filterCategories(searchController.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return CategoryElement(
                  category: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopicsListView(
                          category: category,
                          isAdmin: isAdmin,

                        ),
                      ),
                    );
                  },
                  onEdit: isAdmin ? () => _showEditCategoryPopup(context, category) : null,
                  onDelete: isAdmin ? () => _showDeleteConfirmationPopup(context, category) : null,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: () {
          _showCreateCategoryPopup(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Create Category',
        heroTag: 'createCategoryFAB',
      )
          : null,
    );
  }

  // API call to create a new category
  Future<void> _createCategory(String name) async {
    final response = await http.post(
      Uri.parse('http://192.168.43.42:9090/categories'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 201) {
      _fetchCategories(); // Refresh categories
    } else {
      print('Failed to create category: ${response.body}');
    }
  }

  void _showCreateCategoryPopup(BuildContext context) {
    TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Category'),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(hintText: 'Enter category name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _createCategory(categoryController.text);
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // API call to edit a category
  Future<void> _editCategory(String id, String name) async {
    final response = await http.put(
      Uri.parse('http://192.168.43.42:9090/categories/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name}),
    );

    if (response.statusCode == 200) {
      _fetchCategories(); // Refresh categories
    } else {
      print('Failed to edit category: ${response.body}');
    }
  }

  void _showEditCategoryPopup(BuildContext context, TopicCategory category) {
    TextEditingController categoryController = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Category'),
          content: TextField(
            controller: categoryController,
            decoration: InputDecoration(hintText: 'Edit category name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editCategory(category.id, categoryController.text);
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // API call to delete a category
  Future<void> _deleteCategory(String id) async {
    final response = await http.delete(Uri.parse('http://192.168.43.42:9090/categories/$id'));

    if (response.statusCode == 200) {
      _fetchCategories(); // Refresh categories
    } else {
      print('Failed to delete category: ${response.body}');
    }
  }

  void _showDeleteConfirmationPopup(BuildContext context, TopicCategory category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete the category "${category.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteCategory(category.id);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
