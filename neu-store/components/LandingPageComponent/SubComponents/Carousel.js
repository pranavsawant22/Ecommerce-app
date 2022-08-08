import client from "../../../utils/client";
import { urlFor } from "../../../utils/image";
import { useEffect, useState } from "react";
import { CircularProgress, Alert, Paper, Button } from "@mui/material";
import Carousel from "react-material-ui-carousel";
import styleClasses from "../../../styles/Carousel.module.css";

function CaraouselComponent(props) {
  const [state, setState] = useState({
    slides: [],
    loading: true,
    error: "",
  });
  const { slides, loading, error } = state;
  useEffect(() => {
    const fetchData = async () => {
      try {
        const data = await client.fetch(`*[_type == "carousel"]`);
        const slidesArray = [];
        for (let index = 0; index < data.length; index++) {
          const element = data[index];
          const url = urlFor(element.image);
          const title = element.name;
          slidesArray.push({ title, url });
        }
        if (data.length !== 0) {
          setState({ ...state, slides: slidesArray, loading: false });
        } else {
          setState({ ...state, error: err.message, loading: false });
        }
      } catch (err) {
        setState({ ...state, error: err.message, loading: false });
      }
    };
    fetchData();
  }, []);

  return (
    <>
      {loading ? (
        <CircularProgress />
      ) : error ? (
        <Alert variant="error">{error}</Alert>
      ) : (
        <Carousel>
          {slides.map((item) => (
            <Item item={item} />
          ))}
        </Carousel>
      )}
    </>
  );
}
function Item(props) {
  return <img src={props.item.url} className={styleClasses.carousel}></img>;
}

export default CaraouselComponent;
