import {
  Button,
  List,
  ListItem,
  TextField,
  Typography,
  Stack,
} from "@mui/material";
import jsCookie from "js-cookie";
import { useRouter } from "next/router";
import React, { useContext, useEffect } from "react";
import { Controller, useForm } from "react-hook-form";
import Form from "../Form";
import { Store } from "../../utils/Store";
import axios from "axios";
import { logout } from "../../utils/logout";

const ChangeAddressForm = ({ props }) => {
  const router = useRouter();
  const { state, dispatch } = useContext(Store);
  const { userBearerToken } = state;

  const {
    handleSubmit,
    control,
    formState: { errors },
    setValue,
  } = useForm();

  useEffect(() => {
    setValue("name", props.name);
    setValue("buildingInfo", props.buildingInfo);
    setValue("landmark", props.landmark);
    setValue("city", props.city);
    setValue("pincode", props.pincode);
    setValue("state", props.state);
  }, [setValue, props]);

  const submitHandler = async ({
    name,
    buildingInfo,
    landmark,
    city,
    pincode,
    state,
  }) => {
    try {
      const { data } = await axios.put(
        `https://auth-service-capstone.herokuapp.com/api/v1/user/address/${props._id}`,
        {
          name: name,
          buildingInfo: buildingInfo,
          state: state,
          city: city,
          landmark: landmark,
          pincode: pincode,
        },
        { headers: { Authorization: `Bearer ${userBearerToken}` } }
      );
      const { addresses } = data.addresses;
      dispatch({ type: "ADD_ADDRESS", payload: addresses });
      jsCookie.set("userAddress", JSON.stringify(addresses));
      window.alert("Address updated");
    } catch (error) {
      if (error.message.includes("401")) {
        logout(router,dispatch);
      } else {
        window.alert("Something Went Wrong please try again later");
      }
    }
  };

  const deleteHandler = async (event) => {
    event.preventDefault();
    try {
      var result = window.confirm(`Press ok to delete address ${props.name}`);
      if (result == true) {
        try{
        const { data } = await axios.delete(
          `https://auth-service-capstone.herokuapp.com/api/v1/user/address/${props._id}`,
          { headers: { Authorization: `Bearer ${userBearerToken}` } }
        );
        const { addresses } = data.addresses;
        router.reload(window.location.pathname);
        dispatch({ type: "ADD_ADDRESS", payload: addresses });
        jsCookie.set("userAddress", JSON.stringify(addresses));
        window.alert("Address Deleted");
        }catch(error){
          if (error.message.includes("401")) {
            logout(router,dispatch);
          } else {
            window.alert("Something Went Wrong please try again later");
          }
        }
      } else {
        console.log("Cancel was pressed.");
        return;
      }
    } catch (err) {
      logout(router, dispatch);
      router.push("/auth/login");
    }
  };
  return (
    <Stack>
      <Form onSubmit={handleSubmit(submitHandler)}>
        
        <Typography
          component="h1"
          variant="h1"
          align="center"
          color="primary"
          fontSize="40px"
        >
          Address
        </Typography>
        <List>
          <ListItem>
            <Controller
              name="name"
              control={control}
              defaultValue=""
              rules={{
                required: true,
                minLength: 2,
              }}
              render={({ field }) => (
                <TextField
                  variant="outlined"
                  fullWidth
                  id="name"
                  label="Name"
                  inputProps={{ type: "text" }}
                  error={Boolean(errors.name)}
                  helperText={
                    errors.name
                      ? errors.name.type === "minLength"
                        ? "Name length is more than 1"
                        : "Name is required"
                      : ""
                  }
                  {...field}
                ></TextField>
              )}
            ></Controller>
          </ListItem>
          <ListItem>
            <Controller
              name="buildingInfo"
              control={control}
              defaultValue=""
              rules={{
                required: true,
                minLength: 2,
              }}
              render={({ field }) => (
                <TextField
                  variant="outlined"
                  fullWidth
                  id="buildingInfo"
                  label="BuildingInfo"
                  inputProps={{ type: "text" }}
                  error={Boolean(errors.name)}
                  helperText={
                    errors.buildingInfo
                      ? errors.buildingInfo.type === "minLength"
                        ? "buildingInfo length is more than 1"
                        : "buildingInfo is required"
                      : ""
                  }
                  {...field}
                ></TextField>
              )}
            ></Controller>
          </ListItem>
          <ListItem>
            <Controller
              name="landmark"
              control={control}
              defaultValue=""
              rules={{
                required: true,
                minLength: 2,
              }}
              render={({ field }) => (
                <TextField
                  variant="outlined"
                  fullWidth
                  id="landmark"
                  label="Landmark"
                  inputProps={{ type: "text" }}
                  error={Boolean(errors.name)}
                  helperText={
                    errors.landmark
                      ? errors.landmark.type === "minLength"
                        ? "landmark length is more than 1"
                        : "landmark is required"
                      : ""
                  }
                  {...field}
                ></TextField>
              )}
            ></Controller>
          </ListItem>
          <ListItem>
            <Controller
              name="city"
              control={control}
              defaultValue=""
              rules={{
                required: true,
                minLength: 2,
              }}
              render={({ field }) => (
                <TextField
                  variant="outlined"
                  fullWidth
                  id="city"
                  label="City"
                  inputProps={{ type: "text" }}
                  error={Boolean(errors.name)}
                  helperText={
                    errors.city
                      ? errors.city.type === "minLength"
                        ? "City length is more than 1"
                        : "City is required"
                      : ""
                  }
                  {...field}
                ></TextField>
              )}
            ></Controller>
          </ListItem>
          <ListItem>
            <Controller
              name="pincode"
              control={control}
              defaultValue=""
              rules={{
                required: true,
                minLength: 6,
              }}
              render={({ field }) => (
                <TextField
                  variant="outlined"
                  fullWidth
                  id="pincode"
                  label="Pin-code"
                  inputProps={{ type: "text" }}
                  error={Boolean(errors.name)}
                  helperText={
                    errors.street
                      ? errors.street.type === "minLength"
                        ? "Pin length is more than 5"
                        : "Pin is required"
                      : ""
                  }
                  {...field}
                ></TextField>
              )}
            ></Controller>
          </ListItem>
          <ListItem>
            <Controller
              name="state"
              control={control}
              defaultValue=""
              rules={{
                required: true,
                minLength: 2,
              }}
              render={({ field }) => (
                <TextField
                  variant="outlined"
                  fullWidth
                  id="state"
                  label="State"
                  inputProps={{ type: "text" }}
                  error={Boolean(errors.name)}
                  helperText={
                    errors.state
                      ? errors.state.type === "minLength"
                        ? "Name length is more than 1"
                        : "Name is required"
                      : ""
                  }
                  {...field}
                ></TextField>
              )}
            ></Controller>
          </ListItem>
          <ListItem>
            <Button variant="contained" type="submit" fullWidth color="primary">
              Update
            </Button>
          </ListItem>
          <ListItem>
            <Button
              variant="contained"
              fullWidth
              color="primary"
              onClick={deleteHandler}
            >
              Delete
            </Button>
          </ListItem>
        </List>
      </Form>
    </Stack>
  );
};

export default ChangeAddressForm;
