import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todolist/model/TODO.dart';
import 'package:todolist/ui/create_todo/CreateTODOModel.dart';
import 'package:todolist/ui/home/TODOListModel.dart';

class CreateTODOPage extends StatefulWidget {
  final String title;

  CreateTODOPage(this.title, { Key key }) : super(key: key);

  @override
  _CreateTODOPageState createState() => _CreateTODOPageState();
}

class _CreateTODOPageState extends State<CreateTODOPage> {
  final TextEditingController _textController = TextEditingController();
  final _imagePicker = ImagePicker();

  var _init = false;

  @override
  Widget build(BuildContext context) {
    final TODO todo = ModalRoute.of(context).settings.arguments;

    if (todo != null && !_init) {
      _init = true;
      Provider.of<CreateTODOModel>(context, listen: false).todo = todo;
      _textController.text = todo.text;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
    );
  }

  /// Build body widget.
  ///
  ///
  Widget _buildBody() => SingleChildScrollView(
    child: Container(
      margin: EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildPhoto(),
          _buildText(),
          _buildStatus(),
          _buildNotify(),
          _buildSave(),
        ],
      ),
    ),
  );

  /// Build photo widget.
  /// 
  /// 
  Widget _buildPhoto() {
    final photoSize = 200.0;

    return Center(
      child: Consumer<CreateTODOModel>(
        builder: (context, createTODOModel, child) => Column(
          children: <Widget>[
            createTODOModel.photo.isEmpty ? 
                Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: photoSize,
                ) : 
                Image.file(
                  File(createTODOModel.photo),
                  width: photoSize,
                ),
            _buildPhotoButtons(createTODOModel),
          ],
        ),
      ),
    );
  }

  /// Build photo's selection buttons widget.
  ///
  ///
  Widget _buildPhotoButtons(CreateTODOModel createTODOModel) {
    List<Widget> buttons = [
      _buildPhotoSelectionButton(Icons.camera, imageSrc: ImageSource.camera),
      _buildPhotoSelectionButton(Icons.image, imageSrc: ImageSource.gallery)
    ];

    if (createTODOModel.photo.isNotEmpty) {
      buttons.add(_buildPhotoSelectionButton(Icons.clear, color: Colors.red));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons,
    );
  }

  /// Build photo's selection button.
  ///
  ///
  Widget _buildPhotoSelectionButton(
    IconData iconData, { Color color = Colors.blue, ImageSource imageSrc }
  ) => IconButton(
    icon: Icon(iconData),
    iconSize: 30.0,
    color: color,
    onPressed: () => _showImagePicker(imageSrc)
  );

  /// Show image picker.
  ///
  ///
  Future<void> _showImagePicker(ImageSource src) async {
    final model = Provider.of<CreateTODOModel>(context, listen: false);
    
    if (src == null) {
      model.photo = '';
      return;
    }

    final pickedFile = await _imagePicker.getImage(source: src);

    if (pickedFile == null) {
      return;
    }

    model.photo = pickedFile.path;
  }

  /// Build input text widget.
  ///
  ///
  Widget _buildText() => TextField(
    controller: _textController,
    decoration: InputDecoration(
      hintText: 'Text',
    ),
    onChanged: (text) {
      Provider.of<CreateTODOModel>(context, listen: false).text = text;
    },
  );

  /// Build "Status" radio group widget.
  ///
  ///
  Widget _buildStatus() => Consumer<CreateTODOModel>(
    builder: (context, createTODOModel, child) => _buildRadioGroup<bool>(
      'Status',
      createTODOModel.status,
      { false: 'Pending', true: 'Done' },
      (value) => createTODOModel.status = value
    ),
  );

  /// Build "Notify" radio group widget.
  ///
  ///
  Widget _buildNotify() => Consumer<CreateTODOModel>(
    builder: (context, createTODOModel, child) => _buildRadioGroup<bool>(
      'Notify',
      createTODOModel.notify,
      { false: '5 mins', true: '10 mins' },
      (value) => createTODOModel.notify = value
    ),
  );

  /// Build "Save" button widget.
  ///
  ///
  Widget _buildSave() => Builder(
    builder: (context) => Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      child: RaisedButton(
        child: Text('Save'),
        onPressed: () async {
          bool res = await Provider.of<CreateTODOModel>(context, listen: false).save();

          if (res) {
            // save successful
            Provider.of<TODOListModel>(context, listen: false).refresh();
            Navigator.pop(context);
            return;
          }

          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please input text',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red,
            )
          );
        },
      ),
    )
  );

  /// Build radio group widget.
  /// 
  /// [name] is the title of the radio group.
  /// 
  /// [groupState] is the state of the radio group.
  /// 
  /// [radioItems] contains the data for each radio button.
  /// 
  /// [onTap] is the callback function when a radio button is tapped.
  /// Use this callback function to update the radio group state.
  Widget _buildRadioGroup<T>(
    String name, T groupState, Map<T, String> radioItems, Function onTap
  ) => Row(
    children: <Widget>[
      Text('$name : '),
      ...radioItems.entries.map((e) => Row(
        children: <Widget>[
          Radio(
            value: e.key,
            groupValue: groupState,
            onChanged: onTap,
          ),
          Text(e.value),
        ],
      )).toList(),
    ],
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}