import React from "react";
import { useState, useEffect, useContext } from "react";
import axios from "axios";
import client from "../../utils/client";
import DeleteIcon from "@mui/icons-material/Delete";
import ShoppingCartIcon from "@mui/icons-material/ShoppingCart";

import { Store } from "../../utils/Store";
import {
  TableCell,
  TableRow,
  Typography,
  Button,
  CircularProgress,
  Alert,
} from "@mui/material";
import { urlForThumbnail } from "../../utils/image";
import Image from "next/image";

export default function WishlistListItems(props) {
  const { state, dispatch } = useContext(Store);
  const { userBearerToken, userInfo } = state;
  const productType = props.props.split(":")[0];
  const slug = props.props.split(":")[1];
  const [stateSanity, setState] = useState({
    data: null,
    product: null,
    loading: true,
    error: "",
  });
  const { data, product, loading, error } = stateSanity;
  useEffect(() => {
    const wishlistData = async () => {
      if (productType === "Smartphone") {
        try {
          data = await client.fetch(
            `
            *[_type == "product" && catagory.productsku.SmartPhone.smartphoneSKU.slug.current == $slug][0]`,
            { slug }
          );
          const product = data.catagory.productsku.SmartPhone.smartphoneSKU;
          product.productId = data.productId;
          setState({ ...stateSanity, data, product, loading: false });
        } catch (err) {
          setState({ ...stateSanity, error: err.message, loading: false });
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
          setState({ ...stateSanity, data, product, loading: false });
        } catch (err) {
          setState({ ...stateSanity, error: err.message, loading: false });
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
          setState({ ...stateSanity, data, product, loading: false });
        } catch (err) {
          setState({ ...stateSanity, error: err.message, loading: false });
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
          setState({ ...stateSanity, data, product, loading: false });
        } catch (err) {
          setState({ ...stateSanity, error: err.message, loading: false });
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
          setState({ ...stateSanity, data, product, loading: false });
        } catch (err) {
          setState({ ...stateSanity, error: err.message, loading: false });
        }
      }
    };
    wishlistData();
  }, []);

  const addToCartHandler = async () => {
    try {
      const sku_id = props.props;
      const quantity = 1;
      const data = await axios.post(
        "https://auth-service-capstone.herokuapp.com/api/v1/cart/add-cart-item",
        {
          sku_id,
          quantity,
        },
        { headers: { Authorization: `Bearer ${userBearerToken}` } }
      );
      dispatch({
        type: "CART_ADD_ITEM",
        payload: {
          kind: productType,
          productskuName: product.productskuName,
          countInStock: product.countInStock,
          slug: product.slug.current,
          price: product.price,
          image: urlForThumbnail(product.image),
          quantity,
        },
      });
      window.alert(`Product added to Cart`);
    } catch (error) {
      window.alert("Product Already in Cart");
    }
  };

  const removeWishlistHandler = async (e) => {
    e.preventDefault();
    try {
      const sku_id = props.props;
      const data = await axios.put(
        "https://auth-service-capstone.herokuapp.com/api/v1/wishlist/remove-item-from-wishlist",
        {
          sku_id,
        },
        { headers: { Authorization: `Bearer ${userBearerToken}` } }
      );
      window.alert(`Product removed`);
    } catch (error) {
      window.alert("not received");
    }
  };

  return (
    <>
      {loading ? (
        <CircularProgress />
      ) : error ? (
        <Alert variant="error">{error}</Alert>
      ) : (
        <TableRow key={product.id}>
          <TableCell>
            <Image
              src={urlForThumbnail(product.image)}
              alt={product.name}
              width={50}
              height={50}
            />
          </TableCell>
          <TableCell>
            <Typography>{product.productskuName}</Typography>
          </TableCell>
          <TableCell align="right">{product.price}</TableCell>
          <TableCell align="right">
            <Button
              variant="outlined"
              color="error"
              onClick={removeWishlistHandler}
            >
              <DeleteIcon></DeleteIcon>
            </Button>
          </TableCell>
          <TableCell align="right">
            <Button
              variant="contained"
              color="secondary"
              onClick={() => addToCartHandler()}
            >
              <ShoppingCartIcon />
            </Button>
          </TableCell>
        </TableRow>
      )}
    </>
  );
}
