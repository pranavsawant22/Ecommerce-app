import NextLink from "next/link";
import Head from "next/head";
import Layout from "../components/Layout";
import CheckoutItemList from "../components/Checkout/CheckoutItemList";

import {
  Typography,
  Container,
  Box,
  Link,
  Alert,
  CircularProgress,
  AlertTitle,
  Button,
  Grid,
  FormControl,
  InputLabel,
  List,
  ListItem,
  MenuItem,
  Select,
  TextField,
  Stack,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Item,
  Card,
} from "@mui/material";
import { Store } from "../utils/Store";
import axios from "axios";
import { useContext, useState, useEffect } from "react";
import * as React from "react";
import { useRouter } from "next/router";

export default function Checkout() {
  const router = useRouter();
  const [addressValue, setAddressValue] = React.useState("");
  const [addressClicked, setAddressCliked] = React.useState(false);
  const [addressAvailable, setAddressAvailable] = React.useState(false);

  const { state, dispatch } = useContext(Store);
  const { userAddress, userInfo, userBearerToken } = state;
  const { cart } = state;

  useEffect(() => {
    if (userInfo === null) {
      router.push("/auth/login");
    } else {
      if (addressValue !== "") {
        setAddressCliked(true);
      }
      if (userAddress.length > 0) {
        setAddressAvailable(true);
      }
    }
  }, [addressValue, addressAvailable, Store]);

  const handleChange = (event) => {
    setAddressValue(event.target.value);
  };

  const addAddressHandler = (event) => {
    event.preventDefault();
    router.push("/add-address");
  };

  //console.log(userAddress[addressValue]);
  console.log(cart.cartItems);

  let skuIdCheckout = [];
  let totalPrice = 0;
  for (let i = 0; i < cart.cartItems.length; i++) {
    const checkoutItem = {};
    const sku = cart.cartItems[i].kind + ":" + cart.cartItems[i].slug;
    totalPrice += cart.cartItems[i].quantity * cart.cartItems[i].price;
    checkoutItem["sku_id"] = sku;
    checkoutItem["price"] = totalPrice;
    for (let j = 0; j < cart.cartItems[i].quantity; j++) {
      skuIdCheckout.push(checkoutItem);
    }
  }
  console.log(skuIdCheckout);
  //console.log(totalPrice);

  const addOrderHandler = async () => {
    try {
      console.log("hello");
      let checkoutAddress = userAddress[addressValue];
      checkoutAddress["building"] = checkoutAddress.buildingInfo;
      const data = await axios.post(
        "https://auth-service-capstone.herokuapp.com/api/v1/order/add-order",
        {
          address: checkoutAddress,
          total_price: totalPrice,
          items: skuIdCheckout,
          status: "NOT_SHIPPED",
        },
        { headers: { Authorization: `Bearer ${userBearerToken}` } }
      );
      window.alert(`Order Placed`);
      try {
        const data = await axios.delete(
          "https://auth-service-capstone.herokuapp.com/api/v1/cart/delete-all-cart-item",
          {
            headers: { Authorization: `Bearer ${userBearerToken}` },
          }
        );
        dispatch({ type: "CART_CLEAR" });
      } catch (error) {
        window.alert("OOPS, try again.");
      }
      router.push("/orderhistory");
    } catch (error) {
      window.alert("Please Add Address");
    }
  };

  return (
    <>
      <div>
        <Grid container spacing={1}>
          <Grid item md={9} xs={12}>
            <Typography variant="h1" gutterBottom>
              CHECKOUT
            </Typography>
          </Grid>
          <Grid item md={3} xs={12}>
            {/* <AddressDropdownInCheckout /> */}
            <Stack spacing={2} justifyContent="center">
              <FormControl fullWidth>
                <InputLabel id="demo-simple-select-label">Address</InputLabel>
                <Select
                  labelId="demo-simple-select-label"
                  id="demo-simple-select"
                  value={addressValue}
                  label="address"
                  onChange={handleChange}
                >
                  {userAddress?.map((address) => (
                    <MenuItem value={address.serialId}>{address.name}</MenuItem>
                  ))}
                </Select>
              </FormControl>
              {!addressAvailable && (
                <Button
                  variant="contained"
                  fullWidth
                  color="primary"
                  padding="10px"
                  onClick={addAddressHandler}
                >
                  No Address Found please Add Address
                </Button>
              )}
            </Stack>
          </Grid>
        </Grid>
      </div>
      {
        <Container>
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
                      </TableRow>
                    </TableHead>
                    <TableBody>
                      {cart.cartItems.map((item) => (
                        <CheckoutItemList
                          key={item.productSkuName}
                          props={item}
                        ></CheckoutItemList>
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
                        Total (
                        {cart.cartItems.reduce((a, c) => a + c.quantity, 0)}{" "}
                        items) : ₹{" "}
                        {cart.cartItems.reduce(
                          (a, c) => a + c.quantity * c.price,
                          0
                        )}
                      </Typography>
                    </ListItem>
                    <ListItem>
                      <Button
                        fullWidth
                        color="primary"
                        variant="contained"
                        onClick={() => addOrderHandler()}
                      >
                        Place Order
                      </Button>
                    </ListItem>
                  </List>
                </Card>
              </Grid>
            </Grid>
          </>
        </Container>
      }
    </>
  );
}
