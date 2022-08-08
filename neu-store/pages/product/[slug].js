import {
  Alert,
  Box,
  Button,
  Card,
  CircularProgress,
  Grid,
  Link,
  List,
  ListItem,
  Rating,
  Typography,
} from "@mui/material";
import Image from "next/image";
import NextLink from "next/link";
import { useEffect, useState, useContext } from "react";
import ProductReview from "../../components/Products/ProductReview";
import SmartPhone from "../../components/Products/SmartPhone";
import Apparels from "../../components/Products/Apparels";
import classes from "../../utils/classes";
import client from "../../utils/client";
import { urlFor, urlForThumbnail } from "../../utils/image";
import { Store } from "../../utils/Store";
import axios from "axios";
import Tv from "../../components/Products/Tv";
import Laptop from "../../components/Products/Laptop";
import Books from "../../components/Products/Books";
import { logout } from "../../utils/logout";
import { useRouter } from "next/router";

export default function ProductScreen(props) {
  const router = useRouter();
  let { slug } = props;
  const productType = slug.split(":")[0];
  slug = slug.split(":")[1];

  const { state, dispatch } = useContext(Store);
  const { cart, userBearerToken, userInfo } = state;

  const [stateSanity, setState] = useState({
    data: null,
    product: null,
    loading: true,
    error: "",
  });

  const { data, product, loading, error } = stateSanity;
  useEffect(() => {
    const fetchData = async () => {
      if (productType === "Smartphone") {
        try {
          const data = await client.fetch(
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

    fetchData();
  }, []);

  const addToCartHandler = async () => {
    if (!userInfo) {
      window.alert("Please Login to add Item to cart");
      router.push("/auth/login");
      return;
    }
    const existItem = cart.cartItems.find(
      (x) => x.slug === product.slug.current
    );
    const quantity = existItem ? existItem.quantity + 1 : 1;
    if (product.countInStock < quantity) {
      window.alert("Sorry. Product is out of stock");
      return;
    }
    if (existItem) {
      try {
        const sku_id = productType + ":" + slug;
        const data = await axios.patch(
          "https://auth-service-capstone.herokuapp.com/api/v1/cart/update-cart-item",
          {
            sku_id,
            quantity,
          },
          { headers: { Authorization: `Bearer ${userBearerToken}` } }
        );
      } catch (error) {
        if (error.message.includes("401")) {
          logout(router, dispatch);
          return;
        } else {
          window.alert("Product Already in Cart");
        }
      }
    } else {
      try {
        const sku_id = productType + ":" + slug;
        console.log("hamari skuid " + sku_id);
        const data = await axios.post(
          "https://auth-service-capstone.herokuapp.com/api/v1/cart/add-cart-item",
          {
            sku_id,
            quantity,
          },
          { headers: { Authorization: `Bearer ${userBearerToken}` } }
        );
      } catch (error) {
        if (error.message.includes("401")) {
          logout(router, dispatch);
          return;
        } else {
          window.alert("Something Went Wrong please try again later");
        }
      }
    }
    if (existItem) {
      window.alert(
        `${product.productskuName} is already in cart. Quantity updated to : ${quantity}`
      );
    } else {
      window.alert(`Added ${product.productskuName} to cart`);
    }
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
  };

  return (
    <>
      {loading ? (
        <CircularProgress />
      ) : error ? (
        <Alert variant="error">{error}</Alert>
      ) : (
        <Box>
          <Box sx={classes.section}>
            <NextLink href="/" passHref>
              <Link>
                <Typography>Back to Homepage</Typography>
              </Link>
            </NextLink>
          </Box>
          <Grid container spacing={1}>
            <Grid item md={6} xs={12}>
              <Image
                src={urlFor(product.image)}
                alt={product.name}
                layout="responsive"
                width={300}
                height={300}
              />
            </Grid>
            <Grid md={3} xs={12}>
              <List>
                <ListItem>
                  <Typography component="h1" variant="h1">
                    {product.productskuName}
                  </Typography>
                </ListItem>
                <ListItem>Category: {data.catagory.productsku.kind}</ListItem>
                <ListItem>Brand: {data.brand}</ListItem>
                <ListItem>
                  <Rating value={data.rating} readOnly></Rating>
                </ListItem>
                {productType === "Smartphone" && <SmartPhone props={product} />}
                {productType === "Apparels" && <Apparels props={product} />}
                {productType === "Tv" && <Tv props={product} />}
                {productType === "Laptop" && <Laptop props={product} />}
                {productType === "Books" && <Books props={product} />}
              </List>
            </Grid>
            <Grid item md={3} xs={12}>
              <Card>
                <List>
                  <ListItem>
                    <Grid container>
                      <Grid item xs={6}>
                        <Typography>Price</Typography>
                      </Grid>
                      <Grid item xs={6}>
                        <Typography>₹ {product.price}</Typography>
                      </Grid>
                    </Grid>
                  </ListItem>
                  <ListItem>
                    <Grid container>
                      <Grid item xs={6}>
                        <Typography>Status</Typography>
                      </Grid>
                      <Grid item xs={6}>
                        <Typography>
                          {product.countInStock > 0
                            ? "In stock"
                            : "Unavailable"}
                        </Typography>
                      </Grid>
                    </Grid>
                  </ListItem>
                  <ListItem>
                    <Button
                      fullWidth
                      variant="contained"
                      onClick={addToCartHandler}
                    >
                      Add to cart
                    </Button>
                  </ListItem>
                </List>
              </Card>
            </Grid>
          </Grid>
          <Typography component="h1" variant="h1">
            {" "}
            Reviews
          </Typography>
          <ProductReview props={product} />
        </Box>
      )}
    </>
  );
}

export function getServerSideProps(context) {
  return {
    props: { slug: context.params.slug },
  };
}
