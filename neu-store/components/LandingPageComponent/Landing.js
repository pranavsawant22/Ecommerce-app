import CaraouselComponent from "./SubComponents/carousel";
import BankOffer from "./SubComponents/BankOffer";
import ProdcutAdvertisement from "./SubComponents/ProductAdvertisement";
import CategorySection from "./SubComponents/Category";


function LandingPageComponent(props) {
  return (
    <>
      <CategorySection />
      <CaraouselComponent />
      <BankOffer />
      <ProdcutAdvertisement />
    </>
  );
}

export default LandingPageComponent;
