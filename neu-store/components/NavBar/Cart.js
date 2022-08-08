import React from "react";
import { Link, Typography, Badge } from "@mui/material";
import ShoppingCartIcon from "@mui/icons-material/ShoppingCart";
import NextLink from "next/link";
import { Store } from "../../utils/Store";
import { useContext } from "react";

export const Cart = () => {
  const { state, dispatch } = useContext(Store);
  const { cart } = state;

  return (
    <NextLink href="/cart" passHref>
      <Link>
        <Typography component="span">
          {Array.isArray(cart.cartItems) && cart.cartItems.length > 0 ? (
            <Badge color="secondary" badgeContent={cart.cartItems.length}>
              Cart
              <ShoppingCartIcon />
            </Badge>
          ) : (
            <Badge>
              Cart
              <ShoppingCartIcon />
            </Badge>
          )}
        </Typography>
      </Link>
    </NextLink>
  );
};
