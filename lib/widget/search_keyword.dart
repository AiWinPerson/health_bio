import 'package:flutter/material.dart';

import '../util/color_set.dart';

class SearchKeyword extends StatelessWidget {
  const SearchKeyword({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 45,
      decoration: BoxDecoration(
          color: ColorSet.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorSet.blackOpacity100,
            width: 2,
          )
      ),
      padding: const EdgeInsets.only(left: 15,top: 5,bottom: 5),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Input Your Keyword",
          hintStyle: const TextStyle(color: ColorSet.violet500),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search,color: ColorSet.violet500,),
            onPressed: (){},
          ),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
