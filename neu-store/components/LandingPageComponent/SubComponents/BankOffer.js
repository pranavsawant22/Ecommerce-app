import styles from "../../../styles/BankOffer.module.css";
import { urlFor } from "../../../utils/image";
import { useEffect, useState } from "react";
import client from "../../../utils/client";
import { CircularProgress, Alert } from "@mui/material";
function BankOffer(props) {
  const [state, setState] = useState({
    bankOffer: null,
    loading: true,
    error: "",
  });
  const { bankOffer, loading, error } = state;
  useEffect(() => {
    const fetchData = async () => {
      try {
        const data = await client.fetch(`*[_type == "bankOffer"]`);
        if (data.length !== 0) {
          setState({ ...state, bankOffer: data[0], loading: false });
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
        <div className={styles.banner}>
          <img className={styles.img} src={urlFor(bankOffer.image)} />
        </div>
      )}
    </>
  );
}

export default BankOffer;
