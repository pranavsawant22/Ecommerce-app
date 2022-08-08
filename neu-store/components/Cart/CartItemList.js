import {
  TableCell,
  TableRow,
  Typography,
  Button,
  Select,
  MenuItem,
} from "@mui/material";
import { useContext } from "react";
import DeleteIcon from "@mui/icons-material/Delete";
import StarBorderIcon from "@mui/icons-material/StarBorder";
import Image from "next/image";
import { Store } from "../../utils/Store";
import axios from "axios";

export default function CartItemList({ props }) {
  const { state, dispatch } = useContext(Store);
  const { userBearerToken, userInfo } = state;

  const updateCartHandler = async (quantity) => {
    const sku_id = props.kind + ":" + props.slug;
    try {
      const adddata = await axios.patch(
        "https://auth-service-capstone.herokuapp.com/api/v1/cart/update-cart-item",
        {
          sku_id: sku_id,
          quantity: quantity,
        },
        { headers: { Authorization: `Bearer ${userBearerToken}` } }
      );
      window.alert(`${quantity} ${props.productskuName} added to cart`);
      dispatch({
        type: "CART_ADD_ITEM",
        payload: {
          kind: props.kind,
          productskuName: props.productskuName,
          countInStock: props.countInStock,
          slug: props.slug,
          price: props.price,
          image: props.image,
          quantity,
        },
      });
    } catch (error) {
      window.alert("not received");
    }
  };

  const addToWishlistHandler = async () => {
    try {
      const sku_id = props.kind + ":" + props.slug;
      const data = await axios.post(
        "https://auth-service-capstone.herokuapp.com/api/v1/wishlist/add-wishlist",
        {
          sku_id,
        },
        { headers: { Authorization: `Bearer ${userBearerToken}` } }
      );
      window.alert(`Product added to Wishlist`);
    } catch (error) {
      window.alert("already in wishlist");
    }
  };

  const removeItemHandler = async () => {
    const sku_id = props.kind + ":" + props.slug;
    try {
      const data = await axios.delete(
        "https://auth-service-capstone.herokuapp.com/api/v1/cart/delete-cart-item",
        {
          data: { sku_id: sku_id },
          headers: { Authorization: `Bearer ${userBearerToken}` },
        }
      );
      window.alert(`Product removed`);
      dispatch({ type: "CART_REMOVE_ITEM", payload: props });
    } catch (error) {
      window.alert("not received");
    }
  };

  return (
    <TableRow key={props.productskuName}>
      <TableCell>
        <Image
          src={props.image}
          alt={props.productskuName}
          width={50}
          height={50}
        ></Image>
      </TableCell>
      <TableCell>
        <Typography>{props.productskuName}</Typography>
      </TableCell>
      <TableCell width={60}>
        <Select
          value={props.quantity}
          onChange={(e) => updateCartHandler(e.target.value)}
        >
          {[...Array(props.countInStock).keys()].map((x) => (
            <MenuItem key={x + 1} value={x + 1}>
              {x + 1}
            </MenuItem>
          ))}
        </Select>
      </TableCell>
      <TableCell align="right">{props.price}</TableCell>
      <TableCell align="right">
        <Button
          variant="outlined"
          color="error"
          onClick={() => removeItemHandler()}
        >
          <DeleteIcon />
        </Button>
      </TableCell>
      <TableCell align="right">
        <Button
          variant="contained"
          color="secondary"
          onClick={() => addToWishlistHandler()}
        >
          <StarBorderIcon />
        </Button>
      </TableCell>
    </TableRow>
  );
}
