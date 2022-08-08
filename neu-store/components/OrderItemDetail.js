import React from "react";
import {
  Alert,
  Typography,
  TableCell,
  TableRow,
  CircularProgress,
} from "@mui/material";
import Image from "next/image";
import { useEffect, useState } from "react";
import client from "../utils/client";
import { urlFor } from "../utils/image";

export default function OrderItemDetail({ props }) {
  const productType = props.split(":")[0];
  const slug = props.split(":")[1];
  const productDeliveryId = props.split(":")[2]

  const [state, setState] = useState({
    data: null,
    product: null,
    loading: true,
    error: "",
  });
  const { data, product, loading, error } = state;
  useEffect(() => {
    const fetchData = async () => {
      if (productType === "Smartphone") {
        try {
          data = await client.fetch(
            `*[_type == "product" && catagory.productsku.SmartPhone.smartphoneSKU.slug.current == $slug][0]`,
            { slug }
          );
          product = data.catagory.productsku.SmartPhone.smartphoneSKU;
          console.log(data, product);
          setState({ ...state, data, product, loading: false });
        } catch (err) {
          setState({ ...state, error: err.message, loading: false });
        }
      }
      if (productType === "Apparels") {
        try {
          const data = await client.fetch(
            `
                  *[_type == "product" && catagory.productsku.Apparels.apparelsSKU.slug.current == $slug][0]`,
            { slug }
          );
          const product = data.catagory.productsku.Apparels.apparelsSKU;
          product.productId = data.productId;
          setState({ ...state, data, product, loading: false });
        } catch (err) {
          setState({ ...state, error: err.message, loading: false });
        }
      }
      if (productType === "Tv") {
        try {
          const data = await client.fetch(
            `
                  *[_type == "product" && catagory.productsku.Tv.TvSKU.slug.current == $slug][0]`,
            { slug }
          );
          const product = data.catagory.productsku.Tv.TvSKU;
          product.productId = data.productId;
          setState({ ...state, data, product, loading: false });
        } catch (err) {
          setState({ ...state, error: err.message, loading: false });
        }
      }
      if (productType === "Laptop") {
        try {
          const data = await client.fetch(
            `
                  *[_type == "product" && catagory.productsku.Laptop.LaptopSKU.slug.current == $slug][0]`,
            { slug }
          );
          const product = data.catagory.productsku.Laptop.LaptopSKU;
          product.productId = data.productId;
          setState({ ...state, data, product, loading: false });
        } catch (err) {
          setState({ ...state, error: err.message, loading: false });
        }
      }
      if (productType === "Books") {
        try {
          const data = await client.fetch(
            `
                  *[_type == "product" && catagory.productsku.Books.BooksSKU.slug.current == $slug][0]`,
            { slug }
          );
          const product = data.catagory.productsku.Books.BooksSKU;
          product.productId = data.productId;
          setState({ ...state, data, product, loading: false });
        } catch (err) {
          setState({ ...state, error: err.message, loading: false });
        }
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
        <TableRow key={product.productskuName}>
          <TableCell>
            <Image
              src={urlFor(product.image)}
              alt={product.productskuName}
              width={50}
              height={50}
            ></Image>
          </TableCell>
          <TableCell>
            <Typography>{product.productskuName}</Typography>
          </TableCell>
          <TableCell>
            <Typography>{product.price}</Typography>
          </TableCell>
          <TableCell>
            <Typography>{productDeliveryId}</Typography>
          </TableCell>
        </TableRow>
      )}
    </>
  );
}
