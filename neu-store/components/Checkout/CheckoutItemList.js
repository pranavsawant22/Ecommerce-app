import React from "react";
import { useState, useEffect, useContext } from "react";
import axios from "axios";
import client from "../../utils/client";
import { Store } from "../../utils/Store";
import Image from "next/image";
import {
  CircularProgress,
  Grid,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
} from "@mui/material";

export default function CheckoutItemList(props) {
  const { state, dispatch } = useContext(Store);
  const { userBearerToken, userInfo } = state;

  return (
    <>
      <TableRow key={props.props.productskuName}>
        <TableCell>
          <Image
            src={props.props.image}
            alt={props.productskuName}
            width={50}
            height={50}
          />
        </TableCell>
        <TableCell>
          <Typography>{props.props.productskuName}</Typography>
        </TableCell>
        <TableCell>{props.props.quantity}</TableCell>
        <TableCell align="right">{props.props.price}</TableCell>
      </TableRow>
    </>
  );
}
