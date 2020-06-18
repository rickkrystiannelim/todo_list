import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/model/TODO.dart';
import 'package:todolist/ui/NavigationRoute.dart';
import 'package:todolist/ui/home/TODOListModel.dart';

class TODOListPage extends StatelessWidget {
  final String title;

  TODOListPage(this.title, { Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: _buildMenu(context),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateTo(context, NavigationRoute.CREATE_TODO),
        tooltip: 'Add TODO',
        child: Icon(Icons.add),
      ),
    );
  }

  /// Build action menu widgets.
  /// 
  /// 
  List<Widget> _buildMenu(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.delete_sweep), 
        onPressed: () => showDialog(
          context: context,
          builder: (context) => _buildConfirmDeleteDialog(
            context, 
            "All TODOs will be deleted.",
            onYes: () => Provider.of<TODOListModel>(context, listen: false).deleteAll()
          ),
        ),
      ),
    ];
  }

  /// Build body widget.
  /// 
  /// 
  Widget _buildBody() => Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildList(),
      ],
    ),
  );

  /// Build [TODO] list widget.
  /// 
  /// 
  Widget _buildList() => Expanded(
    child: Consumer<TODOListModel>(
      builder: (context, todoListModel, child) => FutureBuilder(
        future: todoListModel.getAll(),
        builder: (context, AsyncSnapshot<List<TODO>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          else if (snapshot.data.isEmpty) {
            return Center(
              child: Text('No TODOs'),
            );
          }

          // Use local copy of TODO list instead of the snapshot data,
          // because snapshot data does not update instantly.
          // This is to prevent rendering the already dismissed list item.
          return ListView.builder(
            itemCount: todoListModel.todos.length,
            itemBuilder: (context, i) => _buildRow(
              context,
              todoListModel,
              todoListModel.todos[i]
            ),
          );
        }
      ),
    ),
  );

  /// Build [TODO] list row.
  /// 
  /// 
  Widget _buildRow(
    BuildContext context, TODOListModel todoListModel, TODO todo
  ) => Dismissible(
    key: Key(todo.id.toString()), 
    child: Card(
      elevation: 5,
      // color: Colors.lime,
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        leading: todo.photo.isEmpty ? 
            Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: 50,
            ) : 
            Image.file(
              File(todo.photo),
              width: 50,
            ),
        title: Text(todo.text),
        subtitle: Text(todo.status ? 'Done' : 'Pending'),
        trailing: IconButton(
          icon: Icon(
            Icons.done,
            color: todo.status ? Colors.green : Colors.grey,
            size: 30
          ),
          onPressed: () => todoListModel.toggleStatus(todo),
        ),
        onTap: () => _navigateTo(context, NavigationRoute.EDIT_TODO, arg: todo)
      ),
    ),
    confirmDismiss: (direction) => showDialog(
      context: context,
      builder: (context) => _buildConfirmDeleteDialog(context, todo.text),
    ),
    onDismissed: (direction) => todoListModel.delete(todo),
  );

  /// Build delete confirmation dialog.
  ///
  ///
  Widget _buildConfirmDeleteDialog(
    BuildContext context, String message, { Function onYes, Function onNo }
  ) => AlertDialog(
    title: Text('Confirm delete?'),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text('Yes'),
        onPressed: () {
          if (onYes != null) {
            onYes();
          }
          Navigator.of(context).pop(true);
        },
      ),
      FlatButton(
        child: Text('No'),
        onPressed: () {
          if (onNo != null) {
            onNo();
          }
          Navigator.of(context).pop(false);
        }
      ),
    ],
  );

  /// Navigator utility function.
  ///
  ///
  void _navigateTo(
    BuildContext context, String route, { TODO arg }
  ) => Navigator.pushNamed(
    context, route, arguments: arg
  );
}