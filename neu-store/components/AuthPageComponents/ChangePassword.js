import { Fragment, useEffect } from "react";
import { useForm, Controller } from "react-hook-form";
import Form from "../Form";
import { useRouter } from "next/router";
import {
  Button,
  List,
  ListItem,
  TextField,
  Typography,
  Box,
} from "@mui/material";
import axios from "axios";
import { Store } from "../../utils/Store";
import { useContext, useState } from "react";
import styleClass from "../../styles/HeadingLayout.module.css";
import { logout } from "../../utils/logout";

export default function ChangePasswordComponent(props) {
  const { state, dispatch } = useContext(Store);
  const { userBearerToken } = state;
  const router = useRouter();
  const {
    handleSubmit,
    setValue,
    control,
    formState: { errors },
  } = useForm();
  useEffect(() => {
    if (userBearerToken === null) {
      router.push("/auth/login");
    }
  }, []);

  async function submitHandler({
    oldPassword,
    confirmNewPassword,
    newPassword,
  }) {
    try {
      if (confirmNewPassword !== newPassword) {
        window.alert("confirm password and password should be same");
        setValue("newPassword", "");
        setValue("confirmNewPassword", "");
      } else {
        const data = await axios.post(
          "https://auth-service-capstone.herokuapp.com/api/v1/change-password",
          { oldPassword, newPassword },
          { headers: { Authorization: `Bearer ${userBearerToken}` } }
        );
        const { body, status } = data.data;
        window.alert(body);
        if (status) {
          router.push("/");
        }
      }
    } catch (error) {
      if (error.message.includes("401")) {
        logout(router, dispatch);
      } else {
        window.alert(error.response.data.body);
        setValue("oldPassword", "");
      }
    }
  }

  return (
    <Fragment>
      <Box
        sx={{
          marginTop: 8,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
        }}
      >
        <Form onSubmit={handleSubmit(submitHandler)}>
          <div className={styleClass.text_box__parent}>
            <Typography
              component="h1"
              variant="h1"
              align="center"
              className={styleClass.text_box}
            >
              Change Password Setup
            </Typography>
          </div>
          <List>
            <ListItem>
              <Controller
                name="oldPassword"
                control={control}
                defaultValue=""
                rules={{
                  required: true,
                  minLength: 8,
                  maxLength: 14,
                }}
                render={({ field }) => (
                  <TextField
                    variant="outlined"
                    fullWidth
                    id="oldPassword"
                    label="Old Password"
                    inputProps={{ type: "password" }}
                    error={Boolean(errors.oldPassword)}
                    helperText={
                      errors.oldPassword
                        ? errors.oldPassword.type < "minLength" ||
                          errors.oldPassword.type > "maxLength"
                          ? "New Password should be 8 - 14 characterss"
                          : "Password is required"
                        : ""
                    }
                    {...field}
                  ></TextField>
                )}
              ></Controller>
            </ListItem>
            <ListItem>
              <Controller
                name="newPassword"
                control={control}
                defaultValue=""
                rules={{
                  required: true,
                  minLength: 8,
                  maxLength: 14,
                }}
                render={({ field }) => (
                  <TextField
                    variant="outlined"
                    fullWidth
                    id="newPassword"
                    label="New Password"
                    inputProps={{ type: "password" }}
                    error={Boolean(errors.newPassword)}
                    helperText={
                      errors.newPassword
                        ? errors.newPassword.type < "minLength" ||
                          errors.newPassword.type > "maxLength"
                          ? "New Password should be 8 - 14 characterss"
                          : "Password is required"
                        : ""
                    }
                    {...field}
                  ></TextField>
                )}
              ></Controller>
            </ListItem>

            <ListItem>
              <Controller
                name="confirmNewPassword"
                control={control}
                defaultValue=""
                rules={{
                  required: true,
                  minLength: 8,
                  maxLength: 14,
                }}
                render={({ field }) => (
                  <TextField
                    variant="outlined"
                    fullWidth
                    id="confirmNewPassword"
                    label="Confirm New Password"
                    inputProps={{ type: "password" }}
                    error={Boolean(errors.confirmNewPassword)}
                    helperText={
                      errors.confirmNewPassword
                        ? errors.confirmNewPassword.type < "minLength" ||
                          errors.confirmNewPassword.type > "maxLength"
                          ? "New Password should be 8 - 14 characters"
                          : "Password is required"
                        : ""
                    }
                    {...field}
                  ></TextField>
                )}
              ></Controller>
            </ListItem>

            <ListItem>
              <Button variant="contained" type="submit" color="primary">
                Set New Password
              </Button>
            </ListItem>
          </List>
        </Form>
      </Box>
    </Fragment>
  );
}
