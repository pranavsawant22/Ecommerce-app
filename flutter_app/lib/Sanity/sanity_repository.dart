import 'package:flutter/material.dart';
import 'sanity.dart';

final sanityClient = Sanity().sanityClient;

class SanityRepository {
  Future<List> getAllCategoriesThumbnails() async {
    var categoriesMetadata = [];

    const String fetchQuery =
        '*[_type=="catagory"]{kind, "imageUrl": categoryImageMobile.asset->url}';
    final response = await sanityClient.fetch(fetchQuery);
    for (var responseIndex = 0;
        responseIndex < response.length;
        responseIndex++) {
      //extracting and appending image links
      if (response[responseIndex].containsKey("imageUrl")) {
        categoriesMetadata.add(response[responseIndex]);
      }
    }

    return categoriesMetadata;
  }

  Future<List> getAllSpecialDeals() async {
    var specialDealsMetadata = [];

    //query to fetch all the special deals
    const fetchQuery =
        '*[_type == "specialDealAd"]{categoryName, "imageUrl": dealImage.asset->url}';

    final response = await sanityClient.fetch(fetchQuery);

    for (int responseIndex = 0;
        responseIndex < response.length;
        responseIndex++) {
      specialDealsMetadata.add(response[responseIndex]);
    }
    return specialDealsMetadata;
  }

  getComingSoonAdImage() async {
    const fetchQuery =
        '*[_type=="ComingSoonAdvertisement"]{"imageUrl" : ProdAdImage.asset->url}';

    final response = await sanityClient.fetch(fetchQuery);

    return response[0]['imageUrl'].toString();
  }

  getProductAdImage() async {
    const options = " 'name':name, 'slug':slug, 'imageUrl':image.asset->url";
    const fetchQuery = '*[_type=="advertisement"]{$options}';

    final response = await sanityClient.fetch(fetchQuery);

    return response[0];
  }

  getBankOfferImage() async {
    var imgList = [];

    const fetchQuery =
        '*[_type == "bankOfferMobile"]{bankName, "imageUrl": image.asset->url}';

    final response = await sanityClient.fetch(fetchQuery);

    for (int i = 0; i < response.length; i++) {
      imgList.add(response[i]["imageUrl"]);
    }

    return imgList;
  }
}
