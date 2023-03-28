import 'package:flutter/material.dart';

class SearchSuggestionsTable extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onTap;

  const SearchSuggestionsTable({
    Key? key,
    required this.suggestions,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Suggestion')),
      ],
      rows: List<DataRow>.generate(
        suggestions.length,
        (index) => DataRow(
          cells: [
            DataCell(
              InkWell(
                onTap: () {
                  onTap(suggestions[index]);
                  Navigator.of(context)
                    ..pop()
                    ..pop()
                    ..pop();
                },
                child: Text(suggestions[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
