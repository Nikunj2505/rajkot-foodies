import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../widgets/main_drawer.dart';

class FeedbackScreen extends StatefulWidget {
  static const String route = '/feedback';

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _feedbackFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _feedbackFocusNode.dispose();
    _nameController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback(BuildContext context) {
    // close keyboard
    FocusManager.instance.primaryFocus!.unfocus();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _nameController.text = '';
        _feedbackController.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank your for your valuable feedback!'),
          duration: Duration(
            seconds: 2,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      drawer: MainDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _nameFocusNode.unfocus();
                    FocusScope.of(context).requestFocus(_feedbackFocusNode);
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please give some feedback!';
                    }
                    return null;
                  },
                  focusNode: _feedbackFocusNode,
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    labelText: 'Feedback',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () => _submitFeedback(context),
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
