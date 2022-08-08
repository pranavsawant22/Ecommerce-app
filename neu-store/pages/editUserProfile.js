import {
  Alert,
  AlertTitle,
  Button,
  List,
  ListItem,
  TextField,
  Typography,
} from "@mui/material";
import jsCookie from "js-cookie";
import dynamic from "next/dynamic";
import { useRouter } from "next/router";
import React, { useContext, useEffect } from "react";
import { Controller, useForm } from "react-hook-form";
import Form from "../components/Form";
import Layout from "../components/Layout";
import { getError } from "../utils/error";
import { Store } from "../utils/Store";
import axios from "axios";
import { logout } from "../utils/logout";
import InputAdornment from "@mui/material/InputAdornment";

function editUserProfile() {
  const router = useRouter();
  const { state, dispatch } = useContext(Store);
  const { userBearerToken, userInfo } = state;

  const {
    handleSubmit,
    control,
    formState: { errors },
    setValue,
  } = useForm();

  useEffect(() => {
    if (userInfo === null) {
      router.push("/auth/login");
    } else {
      setValue("firstName", userInfo.firstName);
      setValue("lastName", userInfo.lastName);
      setValue("email", userInfo.email);
      setValue("phone", userInfo.phone);
    }
  }, [router, setValue, userInfo]);

  const submitHandler = async ({ firstName, lastName, phone }) => {
    try {
      console.log(firstName, lastName, phone);
      const response = await axios.patch(
        "https://auth-service-capstone.herokuapp.com/api/v1/user/profile",
        { firstName: firstName, lastName: lastName, phone: phone },
        { headers: { Authorization: `Bearer ${userBearerToken}` } }
      );
      const { data, status } = response;
      console.log(data, status);
      if (status === 200) {
        const { firstName, lastName, phone } = data;
        const userDataStore = {
          firstName: firstName,
          lastName: lastName,
          email: userInfo.email,
          phone: phone,
        };
        console.log(userDataStore);
        dispatch({ type: "ADD_USER", payload: userDataStore });
        jsCookie.set("userInfo", JSON.stringify(userDataStore));
        window.alert("Data Updated successfully");
      }
    } catch (error) {
      if (error.message.includes("401")) {
        logout(router,dispatch);
      } else {
        window.alert("Something Went Wrong please try again later");
      }
    }
  };

  return (
    <>
      <Form onSubmit={handleSubmit(submitHandler)}>
        <Typography
          component="h1"
          variant="h1"
          align="center"
          color="primary"
          fontSize="40px"
        >
          Edit User Profile
        </Typography>
        <List>
          <ListItem>
            <Controller
              name="firstName"
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
                  id="firstName"
                  label="First Name"
                  inputProps={{ type: "text" }}
                  error={Boolean(errors.firstName)}
                  helperText={
                    errors.firstName
                      ? errors.firstName.type === "minLength"
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
              name="lastName"
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
                  id="lastName"
                  label="Last Name"
                  inputProps={{ type: "text" }}
                  error={Boolean(errors.lastName)}
                  helperText={
                    errors.lastName
                      ? errors.lastName.type === "minLength"
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
              name="phone"
              control={control}
              defaultValue=""
              rules={{
                required: true,
                pattern:
                  /^(?:(?:\+|0{0,2})91(\s*[\ -]\s*)?|[0]?)?[789]\d{9}|(\d[ -]?){10}\d$/,
              }}
              render={({ field }) => (
                <TextField
                  variant="outlined"
                  fullWidth
                  id="phone"
                  label="Phone"
                  InputProps={{
                    startAdornment: (
                      <InputAdornment position="start">+91 </InputAdornment>
                    ),
                  }}
                  inputProps={{
                    inputMode: "numeric",
                    type: "text",
                    minLength : 10,
                    maxLength : 10,
                  }}
                  error={Boolean(errors.phone)}
                  helperText={
                    errors.phone
                      ? errors.phone.type === "pattern"
                        ? "Phone is not valid"
                        : "Phone is required"
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
        </List>
      </Form>
    </>
  );
}

export default dynamic(() => Promise.resolve(editUserProfile), { ssr: false });
