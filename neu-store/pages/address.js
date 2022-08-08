import {
  Alert,
  AlertTitle,
  Button,
  FormControl,
  InputLabel,
  List,
  ListItem,
  MenuItem,
  Select,
  TextField,
  Typography,
  Stack,
} from "@mui/material";
import jsCookie from "js-cookie";
import dynamic from "next/dynamic";
import { useRouter } from "next/router";
import React, { useContext, useEffect } from "react";
import { Controller, useForm } from "react-hook-form";
import AddAddressForm from "../components/UserAddress/AddAddressForm";
import ChangeAddressForm from "../components/UserAddress/ChangeAddressForm";
import Form from "../components/Form";
import Layout from "../components/Layout";
import { getError } from "../utils/error";
import { Store } from "../utils/Store";
import axios from "axios";

const address = () => {
  const router = useRouter();
  const [addressValue, setAddressValue] = React.useState("");
  const [addressClicked, setAddressCliked] = React.useState(false);
  const [addressAvailable, setAddressAvailable] = React.useState(false);

  const { state } = useContext(Store);
  const { userAddress, userInfo } = state;

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

  return (
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
      {addressAvailable && (
        <Button variant="contained" color="primary" onClick={addAddressHandler}>
          Add New Address
        </Button>
      )}
      {addressClicked && (
        <ChangeAddressForm props={userAddress[parseInt(addressValue)]} />
      )}
    </Stack>
  );
};

export default dynamic(() => Promise.resolve(address), { ssr: false });
