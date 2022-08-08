import 'package:e_comm_tata/Sanity/sanity_repository.dart';
import 'package:flutter/material.dart';
import 'package:e_comm_tata/utils/landing_page/img_constants.dart';
import 'package:e_comm_tata/utils/landing_page/common_service.dart';

ImgConstants imgs = ImgConstants(); //import constant dummy images

class ComingSoonAdvertisement extends StatelessWidget {
  const ComingSoonAdvertisement({Key? key}) : super(key: key);

  ///This class displays a single advertisement of a coming soon product

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration:
          CommonService(context).decorateBoxCircular(), //makes the container circular
      margin: const EdgeInsets.only(bottom: 5.0),
      child: Column(children: <Widget>[
        CommonService(context).alignTextLeft('Coming Soon'),
        const SizedBox(
          height: 5.0,
        ),
        FutureBuilder(
            future: SanityRepository().getComingSoonAdImage(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Image.network(
                  snapshot.data,
                  fit: BoxFit.fitHeight,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white70,
                  ),
                );
              }
            })
      ]),
    );
  }
}
