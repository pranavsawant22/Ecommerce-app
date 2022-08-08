import {
  Typography,
  Container,
  Box,
  Link,
  CircularProgress,
} from "@mui/material";
import Wishlist from "../components/Wishlist/Wishlist";
import { Store } from "../utils/Store";
import axios from "axios";
import { useContext, useState, useEffect } from "react";
import NextLink from "next/link";

export default function wishlist() {
  const wishlistSkuIds = [];
  const [wishlistSkuArray, setWishlistSku] = useState([]);
  const { state } = useContext(Store);
  const { userBearerToken } = state;
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const getWishlist = async () => {
      try {
        const wishlistData = await axios.get(
          "https://auth-service-capstone.herokuapp.com/api/v1/wishlist/get-wishlist",

          { headers: { Authorization: `Bearer ${userBearerToken}` } }
        );
        const dataFromApi = wishlistData["data"];
        const wishlistItemsFromApi = dataFromApi["wishlistitems"];
        setWishlistSku(wishlistItemsFromApi);
        setLoading(false);
      } catch (error) {
        if (error.message.includes("401")) {
          logout(router, dispatch);
          setLoading(false);
        } else if (error.message.includes("404")) {
          setLoading(false);
        } else {
          window.alert("Something Went Wrong please try again later");
          setLoading(false);
        }
      }
    };
    getWishlist();
  }, [wishlistSkuArray]);

  for (let i = 0; i < wishlistSkuArray.length; i++) {
    wishlistSkuIds.push(wishlistSkuArray[i].sku_id);
  }
  return (
    <>
      <Typography variant="h1" gutterBottom>
        MY WISHLIST
      </Typography>
      {loading ? (
        <CircularProgress />
      ) : wishlistSkuArray.length === 0 ? (
        <Box>
          <Typography>
            Wishlist is empty.{" "}
            <NextLink href="/" passHref>
              <Link>Go shopping</Link>
            </NextLink>
          </Typography>
        </Box>
      ) : (
        <Container>
          <Wishlist props={wishlistSkuIds} />
        </Container>
      )}
    </>
  );
}
