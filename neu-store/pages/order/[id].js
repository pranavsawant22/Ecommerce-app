import {
  Card,
  Grid,
  List,
  ListItem,
  Typography,
  Table,
  TableBody,
  TableContainer,
  TableCell,
  TableRow,
  TableHead,
} from "@mui/material";
import dynamic from "next/dynamic";
import React, { useContext, useEffect, useReducer, useState } from "react";
import classes from "../../utils/classes";
import axios from "axios";
import { Store } from "../../utils/Store";
import OrderItemDetail from "../../components/OrderItemDetail";

function OrderScreen({ params }) {
  const { id: orderId } = params;
  const [order, setOrder] = useState([]);
  const { state, dispatch } = useContext(Store);
  const { userBearerToken, userInfo } = state;
  useEffect(() => {
    const fetchOrder = async () => {
      try {
        const data = await axios.get(
          `https://auth-service-capstone.herokuapp.com/api/v1/order/get-order/${orderId}`,
          { headers: { Authorization: `Bearer ${userBearerToken}` } }
        );
        setOrder(data.data);
      } catch (error) {
        window.alert(error.response.data.body);
      }
    };
    fetchOrder();
  }, []);

  const skuIdArray=[]
  order.map((o) => {
    o.items.map((i) => {

      skuIdArray.push(`${i.sku_id}:${i._id}`);
    });
  });


  return (
    <Card title={`Order ${orderId}`}>
      <Typography component="h1" variant="h1">
        Order ID : {orderId}
      </Typography>
      <Grid container spacing={1}>
        <Grid item md={9} xs={12}>
          <Card sx={classes.section}>
            {order.map((o) => (
              <List key={o._id}>
                <ListItem>
                  <Typography component="h1" variant="h1">
                    Shipping Address
                  </Typography>
                </ListItem>
                <ListItem>
                  {o.address.building}, {o.address.landmark}, {o.address.city},{" "}
                  {o.address.state}, {o.address.pincode}
                </ListItem>
                <ListItem>Status:{o.status}</ListItem>
              </List>
            ))}
          </Card>

          <Card sx={classes.section}>
            <List>
              <ListItem>
                <Typography component="h1" variant="h1">
                  Order Details
                </Typography>
              </ListItem>
              <ListItem>
                <TableContainer>
                  <Table>
                    <TableHead>
                      <TableRow>
                        <TableCell>Image</TableCell>
                        <TableCell>Item</TableCell>
                        <TableCell>Price</TableCell>
                        <TableCell>Product Delivery Id</TableCell>
                      </TableRow>
                    </TableHead>

                    <TableBody>
                      {skuIdArray.map((item) => (
                        <OrderItemDetail
                          key={item.productSkuName}
                          props={item}
                        ></OrderItemDetail>
                      ))}
                    </TableBody>
                  </Table>
                </TableContainer>
              </ListItem>
            </List>
          </Card>
        </Grid>
        <Grid item md={3} xs={12}>
          <Card sx={classes.section}>
            {order.map((o) => (
              <List key={o._id}>
                <ListItem>
                  <Typography variant="h2">Order Summary</Typography>
                </ListItem>
                <ListItem>
                  <Grid container>
                    <Grid item xs={6}>
                      <Typography>Items:</Typography>
                    </Grid>
                    <Grid item xs={6}>
                      <Typography align="right">{o.items.length}</Typography>
                    </Grid>
                  </Grid>
                </ListItem>

                <ListItem>
                  <Grid container>
                    <Grid item xs={6}>
                      <Typography>
                        <strong>Total:</strong>
                      </Typography>
                    </Grid>
                    <Grid item xs={6}>
                      <Typography align="right">
                        <strong>Rs.{o.total_price}</strong>
                      </Typography>
                    </Grid>
                  </Grid>
                </ListItem>
              </List>
            ))}
          </Card>
        </Grid>
      </Grid>
    </Card>
  );
}
export function getServerSideProps({ params }) {
  return { props: { params } };
}

export default dynamic(() => Promise.resolve(OrderScreen), { ssr: false });
