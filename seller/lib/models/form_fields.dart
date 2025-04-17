import 'package:flutter/material.dart';
import 'package:flutter_summernote/flutter_summernote.dart';

InputDecoration getInputDecoration(
  String label, {
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: Colors.blueAccent),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
    labelStyle: TextStyle(
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w500,
    ),
    suffixIcon: suffixIcon,
  );
}

// Widget buildQuillEditor({
//   required QuillController controller,
//   required String label,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       sectionTitle(label),
//       const SizedBox(height: 5),
//       QuillSimpleToolbar(
//         controller: controller,
//         configurations: const QuillSimpleToolbarConfigurations(
//           multiRowsDisplay: false,
//         ),
//       ),
//       const SizedBox(height: 5),
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(color: Colors.grey.shade400, width: 1),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
//         child: QuillEditor.basic(
//           controller: controller,
//           focusNode: FocusNode(),
//           configurations: QuillEditorConfigurations(
//             placeholder: label,
//             padding: const EdgeInsets.all(5.0),
//             minHeight: 200,
//           ),
//         ),
//       ),
//     ],
//   );
// }

Widget buildSummernoteEditor(
        {required String label,
        required GlobalKey<FlutterSummernoteState> controller, String? defaultValue}) {
  // controller.currentState!.setText("default text");
  return FlutterSummernote(
    key: controller,
    hint: (defaultValue == null  ||  defaultValue.isEmpty) ? label : "",
    value: defaultValue,
    height: 300,
  );
}

Widget buildDropdownButton({
  required List<String> items,
  required String label,
  required String? value,
  required ValueChanged<String?>? onChanged,
  Widget? disabledHint,
  bool isLoading = false,
}) {
  return Card(
    elevation: 6,
    shadowColor: Colors.grey.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    child: isLoading
        ? const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : DropdownButtonFormField<String>(
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
            value: value,
            decoration: getInputDecoration(label),
            disabledHint: disabledHint,
          ),
  );
}

Widget buildTextFormField(
  String label,
  TextEditingController controller, {
  int? maxLines,
  TextInputType? textInputType,
  String? Function(String? value)? validator,
  Widget? suffixIcon,
  ValueChanged<String>? onSubmitted,
}) {
  return Card(
    elevation: 6,
    shadowColor: Colors.grey.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    child: TextFormField(
      controller: controller,
      decoration: getInputDecoration(
        label,
        suffixIcon: suffixIcon,
      ),
      onFieldSubmitted: onSubmitted,
      maxLines: maxLines,
      validator: validator,
      keyboardType: textInputType,
      onTapOutside: (v) {
        FocusManager.instance.primaryFocus!.unfocus();
      },
    ),
  );
}

class SearchTextField extends StatefulWidget {
  final List<String> items;
  final String? initialValue;
  final Function(String)? onSearch;
  final String label;

  const SearchTextField({
    super.key,
    required this.items,
    required this.onSearch,
    required this.label,
    this.initialValue,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;
  List<String> _filteredItems = [];
  String? initialValue;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
    _filteredItems = widget.items;
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
    if (widget.onSearch != null) {
      widget.onSearch!(query);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _controller,
            decoration: getInputDecoration(widget.label,
                suffixIcon: const Icon(Icons.search)),
          ),
          if (_filteredItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredItems[index]),
                    onTap: () {
                      _controller.text = _filteredItems[index];
                      setState(() {
                        _filteredItems = [];
                      });
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
