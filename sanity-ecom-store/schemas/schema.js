// First, we must import the schema creator
import createSchema from "part:@sanity/base/schema-creator";

// Then import schema types from any plugins that might expose them
import schemaTypes from "all:part:@sanity/base/schema-type";
import catagory from "./catagory";
import smartphone from "./smartphone";
import Apparels from "./Apparels";
import product from "./product";
import BankOffer from "./BankOffer";
import Carousel from "./Carousel";
import ProductAdvertisement from "./ProductAdvertisement";
import CommingSoonAd from "./CommingSoonAd";
import specialDealAd from "./specialDealAd";
import BankOfferMobile from "./BankOfferMobile";
import Books from "./Books";
import Tv from "./Tv";
import Laptop from "./Laptop";

// Then we give our schema to the builder and provide the result to Sanity
export default createSchema({
  // We name our schema
  name: "default",
  // Then proceed to concatenate our document type
  // to the ones provided by any plugins that are installed
  types: schemaTypes.concat([
    Apparels,
    smartphone,
    catagory,
    product,
    BankOffer,
    Carousel,
    ProductAdvertisement,
    CommingSoonAd,
    specialDealAd,
    BankOfferMobile,
    Books,
    Tv,
    Laptop
  ]),
});
