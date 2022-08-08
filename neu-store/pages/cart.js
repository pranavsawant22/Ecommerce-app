import { Typography, Container, Box, Link } from "@mui/material";
import NextLink from "next/link";
import React, { useContext } from "react";
import { Store } from "../utils/Store";
import CartList from "../components/Cart/Cartlist";
import { useRouter } from "next/router";
import dynamic from "next/dynamic";

function Cart() {
  const router = useRouter();
  const { state } = useContext(Store);
  const { cart, userInfo } = state;

  if (userInfo === null) {
    router.push("/auth/login");
  }

  return (
    <>
      <Typography variant="h1" gutterBottom>
        MY CART
      </Typography>
      {!Array.isArray(cart.cartItems) || cart.cartItems.length === 0 ? (
        <Box>
          <Typography>
            Cart is empty.{" "}
            <NextLink href="/" passHref>
              <Link>Go shopping</Link>
            </NextLink>
          </Typography>
        </Box>
      ) : (
        <Container>
          <CartList />
        </Container>
      )}
    </>
  );
}

export default dynamic(() => Promise.resolve(Cart), { ssr: false });
