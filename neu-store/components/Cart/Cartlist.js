import {
  Grid,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
  Button,
  List,
  Link,
  ListItem,
  Card,
} from "@mui/material";
import { useContext } from "react";
import React from "react";
import NextLink from "next/link";
import { Store } from "../../utils/Store";
import CartItemList from "./CartItemList";

export default function CartList() {
  const { state } = useContext(Store);
  const { cart } = state;

  return (
    <>
      <br></br>
      <Grid container spacing={8}>
        <Grid item md={9} xs={12}>
          <TableContainer>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Product</TableCell>
                  <TableCell>Name</TableCell>
                  <TableCell>Quantity</TableCell>
                  <TableCell align="right">Price</TableCell>
                  <TableCell align="right">Remove</TableCell>
                  <TableCell align="right">Add to Wishlist</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {cart.cartItems.map((item) => (
                  <CartItemList
                    key={item.productSkuName}
                    props={item}
                  ></CartItemList>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </Grid>
        <Grid item md={3} xs={12}>
          <Card>
            <List>
              <ListItem>
                <Typography>
                  Total ({cart.cartItems.reduce((a, c) => a + c.quantity, 0)}{" "}
                  items) : ₹{" "}
                  {cart.cartItems.reduce((a, c) => a + c.quantity * c.price, 0)}
                </Typography>
              </ListItem>
              <ListItem>
                <NextLink href="/checkout" passHref>
                  <Link>
                    <Button fullWidth color="primary" variant="contained">
                      Checkout
                    </Button>
                  </Link>
                </NextLink>
              </ListItem>
            </List>
          </Card>
        </Grid>
      </Grid>
    </>
  );
}
