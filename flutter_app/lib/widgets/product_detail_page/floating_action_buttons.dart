import 'package:flutter/material.dart';

import 'floating_button_reuse.dart';

class FloatingActionButtons extends StatelessWidget {
  Map<String, dynamic> productData;
  FloatingActionButtons(this.productData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FloatingButtonReuse(
          productData: productData,
          bottomPosition: 20,
          leftPosition:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? MediaQuery.of(context).size.width * 0.70
                  : MediaQuery.of(context).size.width * 0.52,
          // MediaQuery.of(context).size.width * 0.52,
          rightPosition: 30,
          name: 'Cart',
          heroTag: 'cart',
        ),

// Add more floating buttons if you want
// There is no limit
      ],
    );
  }
}
