import styles from "../../../styles/ProductAdvertisement.module.css";
import { urlFor } from "../../../utils/image";
import { useEffect, useState } from "react";
import client from "../../../utils/client";
import { CircularProgress, Alert } from "@mui/material";
import { useRouter } from "next/router";
function ProdcutAdvertisement(props) {
  const routerObj = useRouter();
  const [state, setState] = useState({
    productAdv: null,
    loading: true,
    error: "",
  });
  const { productAdv, loading, error } = state;
  useEffect(() => {
    const fetchData = async () => {
      try {
        const data = await client.fetch(`*[_type == "advertisement"]`);
        if (data.length !== 0) {
          setState({ ...state, productAdv: data[0], loading: false });
        } else {
          setState({ ...state, error: err.message, loading: false });
        }
      } catch (err) {
        setState({ ...state, error: err.message, loading: false });
      }
    };
    fetchData();
  }, []);
  function onClickHandler(product_detail) {
    routerObj.push("/product/" + product_detail.current);
  }
  return (
    <>
      {loading ? (
        <CircularProgress />
      ) : error ? (
        <Alert variant="error">{error}</Alert>
      ) : (
        <div className={styles.banner}>
          <img
            className={styles.img}
            src={urlFor(productAdv.image)}
            onClick={() => {
              onClickHandler(productAdv.slug);
            }}
          />
        </div>
      )}
    </>
  );
}

export default ProdcutAdvertisement;
