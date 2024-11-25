import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/buttons/secondary_button.dart';

import '../search-filter/row_search_bar.dart';

class HandleUsersRow extends StatelessWidget {
  void onSearchChanged(String text) {
    print(text);
  }

  void onAddUser() {
    print('Add user');
  }

  const HandleUsersRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: RowSearchBar(onSearchChanged: onSearchChanged),
          ),
          const SizedBox(width: 8.0),
          SecondaryButton(
            text: 'Lägg till användare',
            onButtonPressed: onAddUser,
          ),
        ],
      ),
    );
  }
}
