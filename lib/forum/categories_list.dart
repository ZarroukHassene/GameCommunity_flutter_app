import 'package:flutter/material.dart';
import '../entities/ForumUser.dart';
import '../entities/Topic.dart';
import '../entities/TopicCategory.dart';
import 'elements/category_element.dart';
import 'topics_list.dart';

class CategoriesListView extends StatefulWidget {
  final List<TopicCategory> categories;
  final bool isAdmin;

  CategoriesListView({
    Key? key,
    required this.categories,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  _CategoriesListViewState createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  late List<TopicCategory> filteredCategories;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredCategories = widget.categories;
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = widget.categories
          .where((category) =>
          category.name.toLowerCase().contains(query.toLowerCase()))
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
                          isAdmin: widget.isAdmin,
                          topics: category.topics,
                        ),
                      ),
                    );
                  },
                  onEdit: widget.isAdmin
                      ? () {
                    _showEditCategoryPopup(context, category);
                  }
                      : null,
                  onDelete: widget.isAdmin
                      ? () {
                    _showDeleteConfirmationPopup(context, category);
                  }
                      : null,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isAdmin
          ? Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          onPressed: () {
            _showCreateCategoryPopup(context);
          },
          child: Icon(Icons.add),
          tooltip: 'Create Category',
          heroTag: 'createCategoryFAB',
        ),
      )
          : null,
    );
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
              decoration: InputDecoration(hintText: 'Enter category name')
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle creating the new category (no backend yet)
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle editing the category (no backend yet)
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle category deletion (no backend yet)
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