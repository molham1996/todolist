import 'package:flutter/material.dart';

class SliderCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigationToEditPage;
  final Function(String) deleteById;

  const SliderCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigationToEditPage,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    final title = item['title'];
    final subtext = item['subtext'];
    final id = item['id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(title['en']),
        subtitle: Text(subtext['en']),
        trailing: PopupMenuButton(
            onSelected: (value) => {
                  if (value == 'edit')
                    {navigationToEditPage(item)}
                  else if (value == 'delete')
                    {deleteById(id)}
                },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Edit'),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Text('Delete'),
                  value: 'delete',
                ),
              ];
            }),
      ),
    );
  }
}
