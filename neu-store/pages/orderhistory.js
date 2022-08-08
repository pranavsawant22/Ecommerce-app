import {
  Card,
  Button,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
} from "@mui/material";

import React, { useContext, useEffect, useReducer, useState } from "react";
import Layout from "../components/Layout";
import dynamic from "next/dynamic";
import NextLink from "next/link";
import axios from "axios";
import { Store } from "../utils/Store";
import classes from "../utils/classes";
import { useRouter } from "next/router";
import { logout } from "../utils/logout";

function OrderHistoryScreen() {
  const [orders, setOrders] = useState([]);
  const { state, dispatch } = useContext(Store);
  const { userBearerToken, userInfo } = state;
  const router = useRouter();

  useEffect(() => {
    if (userInfo === null) {
      router.push("/auth/login");
    } else {
      const getUserData = async () => {
        try {
          const response = await axios.get(
            "https://auth-service-capstone.herokuapp.com/api/v1/order/get-all-orders",
            { headers: { Authorization: `Bearer ${userBearerToken}` } }
          );
          console.log(response);
          setOrders(response.data);
        } catch (error) {
          if (error.message.includes("404")) {
            window.alert("No Order found Go Shopping!");
            router.push("/");
          } else if (error.message.includes("401")) {
            logout();
          } else {
            window.alert(error.response.data.body);
          }
        }
      };
      getUserData();
    }
  }, []);

  return (
    <Card sx={classes.section}>
      <Typography component="h1" variant="h1">
        Order History
      </Typography>

      <TableContainer>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>ID</TableCell>
              <TableCell>Number of Items</TableCell>
              <TableCell>PAID</TableCell>
              <TableCell>STATUS</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {orders.map((order) => (
              <TableRow key={order._id}>
                {console.log(typeof order.status)}
                <TableCell>{order._id}</TableCell>
                <TableCell>{order.items.length}</TableCell>
                <TableCell>Rs.{order.total_price}</TableCell>
                <TableCell>{order.status}</TableCell>
                <TableCell>
                  <NextLink href={`/order/${order._id}`} passHref>
                    <Button variant="contained">Details</Button>
                  </NextLink>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Card>
  );
}
export default dynamic(() => Promise.resolve(OrderHistoryScreen), {
  ssr: false,
});
