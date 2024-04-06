import "dart:convert";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_json_view/flutter_json_view.dart";

class UploadFilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "File Picker",
        ),
      ),
      body: Container(
        child: FilePickerDemo(
          title: "Pick",
        ),
      ),
    );
  }
}

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({super.key, required this.title});

  final String title;

  @override
  State<FilePickerDemo> createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  FilePickerResult? result;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              (result != null && (result?.isSinglePick ?? false))
                  ? Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                JsonView.string(
                                  "${utf8.decode(result?.files.first.bytes?.toList() ?? [])}",
                                  theme: const JsonViewTheme(
                                      viewType: JsonViewType.collapsible),
                                ),
                                const SizedBox(height: 10),
                              ]))),
                    )
                  : SizedBox.shrink(),
              (result != null && (result?.isSinglePick ?? false))
                  ? Expanded(
                      child: JsonViewer(
                        json: json.decode(utf8
                            .decode(result?.files.first.bytes?.toList() ?? [])),
                      ),
                    )
                  : SizedBox.shrink(),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await FilePicker.platform
                        .pickFiles(allowMultiple: true);
                    if (result == null) {
                      print("No file selected");
                    } else {
                      setState(() {});
                      for (var element in result!.files) {
                        print(element.name);
                      }
                    }
                  },
                  child: const Text("File Picker"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JsonViewer extends StatefulWidget {
  final Map<String, dynamic> json;

  JsonViewer({required this.json});

  @override
  _JsonViewerState createState() => _JsonViewerState();
}

class _JsonViewerState extends State<JsonViewer> {
  Map<String, bool> selectedKeys = {};
  bool visible = false;
  Map<String, dynamic> result = {};

  void updateSelectedKeys(String key, bool value) {
    setState(() {
      selectedKeys[key] = value;
    });
  }

  Widget _buildJsonTree(Map<String, dynamic> json, String parentKey) {
    List<Widget> children = [];

    json.forEach((key, value) {
      String combinedKey = parentKey.isNotEmpty ? '$parentKey.$key' : key;

      children.add(
        CheckboxListTile(
          title: Text(key),
          value: selectedKeys[combinedKey] ?? false,
          onChanged: (bool? value) {
            updateSelectedKeys(combinedKey, value!);
          },
        ),
      );

      if (value is Map<String, dynamic>) {
        children.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildJsonTree(value, combinedKey),
        ));
      } else if (value is List) {
        children.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildJsonList(value, combinedKey),
        ));
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildJsonList(List<dynamic> list, String parentKey) {
    List<Widget> children = [];

    list.asMap().forEach((index, value) {
      String combinedKey = '$parentKey[$index]';

      children.add(
        CheckboxListTile(
          title: Text(combinedKey),
          value: selectedKeys[combinedKey] ?? false,
          onChanged: (bool? value) {
            updateSelectedKeys(combinedKey, value!);
          },
        ),
      );

      if (value is Map<String, dynamic>) {
        children.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildJsonTree(value, combinedKey),
        ));
      } else if (value is List) {
        children.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildJsonList(value, combinedKey),
        ));
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Map<String, dynamic> generateResultJson() {
    Map<String, dynamic> result = {};

    selectedKeys.forEach((key, value) {
      if (value) {
        List<String> keys = key.split('.');
        dynamic current = result;

        for (int i = 0; i < keys.length; i++) {
          final k = keys[i];
          if (i == keys.length - 1) {
            current[k] = widget.json[k];
          } else {
            current[k] ??= {};
            current = current[k];
          }
        }
      }
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildJsonTree(widget.json, ''),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            result = generateResultJson();
            print(jsonEncode(result));
            setState(() {
              visible = true;
            });
          },
          child: Text("Generate Result JSON"),
        ),
        SizedBox(height: 20),
        Visibility(child: Text(jsonEncode(result))),
        SizedBox(height: 20),
      ],
    );
  }
}
