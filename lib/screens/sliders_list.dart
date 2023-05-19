// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_list_app/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list_app/services/slider_service.dart';
import 'package:todo_list_app/utils/snackbar_helper.dart';
import 'package:todo_list_app/widget/slider_card.dart';

class SlidersListPage extends StatefulWidget {
  const SlidersListPage({super.key});

  @override
  State<SlidersListPage> createState() => _SlidersListPageState();
}

class _SlidersListPageState extends State<SlidersListPage> {
  bool isLoading = false;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sliders List"),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchSlider,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
                child: Text(
              'No Sliders Item',
              style: Theme.of(context).textTheme.headlineMedium,
            )),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  return SliderCard(
                      index: index,
                      item: item,
                      navigationToEditPage: navigationToEditPage,
                      deleteById: deleteById
                  );
                }),
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigationToAddPage, label: Text('Add Slider')),
    );
  }

  Future<void> navigationToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddSliderPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchSlider();
  }

  Future<void> navigationToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddSliderPage(slider: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchSlider();
  }

  Future<void> deleteById(String id) async {
    setState(() {
      isLoading = true;
    });
    final url = 'http://137.184.9.159:5244/api/Sliders/$id';
    final uri = Uri.parse(url);

    final response = await http.delete(uri);

    if (response.statusCode == 204) {
      //hiding data only
      final result = items.where((element) => element['id'] != id).toList();
      setState(() {
        items = result;
      });
    } else {
      showErrorMessage(context, message: "delete slider Failed");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchSlider() async {
    setState(() {
      isLoading = true;
    });

    final response = await SliderService.fetchSlider();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: "Fetching sliders Failed");
    }
    setState(() {
      isLoading = false;
    });
  }
}
