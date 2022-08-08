import React from "react";
import WishlistListItems from "./WishlistListItems";
import {
  Grid,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
} from "@mui/material";

function Wishlist(props) {
  return (
    <>
      <br></br>
      <Grid container spacing={4}>
        <Grid item md={12} xs={12}>
          <TableContainer>
            <Table>
              <TableHead>
                <TableRow>
                  <TableCell>Product</TableCell>
                  <TableCell>Name</TableCell>
                  <TableCell align="right">Price</TableCell>
                  <TableCell align="right">Remove</TableCell>
                  <TableCell align="right">Add to Cart</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {props.props.map((item) => (
                  <WishlistListItems props={item} />
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </Grid>
      </Grid>
    </>
  );
}
export default Wishlist;
