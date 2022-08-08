import {
  Button,
  Grid,
  IconButton,
  List,
  ListItem,
  TextField,
  Typography,
} from "@mui/material";
import { makeStyles } from "@material-ui/core/styles";
import NextLink from "next/link";
import axios from "axios";
import React, { Fragment } from "react";
import { useForm, Controller } from "react-hook-form";
import Link from "@mui/material/Link";
import Form from "../Form";
import InputAdornment from "@mui/material/InputAdornment";
import { useRouter } from "next/router";
import { useState } from "react";
import styleClass from "../../styles/HeadingLayout.module.css";
import Visibility from '@mui/icons-material/Visibility';
import VisibilityOff from '@mui/icons-material/VisibilityOff';
import EmailIcon from '@mui/icons-material/Email';

const useStyles = makeStyles({
  input: {
    "& input[type=number]": {
      "-moz-appearance": "textfield",
    },
    "& input[type=number]::-webkit-outer-spin-button": {
      "-webkit-appearance": "none",
      margin: 0,
    },
    "& input[type=number]::-webkit-inner-spin-button": {
      "-webkit-appearance": "none",
      margin: 0,
    },
  },
});
export default function RegisterComponent() {
  const routerObj = useRouter();
  const classes = useStyles();
  const [otpSent, setOtp] = useState(false);
  const [verified, verifyState] = useState(false);
  const [randomToken, setRandomToken] = useState("");
  const [showPassword , showPasswordState] = useState(false);
  const [showConfirmPassword , showConfirmPasswordState] = useState(false);
  const {
    handleSubmit,
    control,
    setValue,
    formState: { errors },
  } = useForm();

  const sentOtpHandler = async ({ email }) => {
    try {
      const { data } = await axios.get(
        "https://auth-service-capstone.herokuapp.com/api/v1/check-email",
        { headers: { email: email } }
      );

      if (data.status) {
        window.alert("you are already registered please login");
        routerObj.push("/auth/login");
      } else {
        const { data, status } = await axios.post(
          "https://auth-service-capstone.herokuapp.com/api/v1/send-otp",
          { email: email }
        );
        if (status === 200) {
          setOtp(true);
        }
      }
    } catch (error) {}
  };

  const verifyOtpHandler = async ({ email, enterotp }) => {
    try {
      const data = await axios.post(
        "https://auth-service-capstone.herokuapp.com/api/v1/validate-otp",
        { email: email, otp: enterotp }
      );
      const { body, status } = data.data;

      if (body !== "") {
        setRandomToken(body);
        verifyState(true);
      }
    } catch (error) {
      const { body, status } = error.response.data;
      window.alert(body);
      setValue("enterotp" , "");
      setOtp(false);
    }
  };

  const submitHandler = async ({
    firstName,
    lastName,
    email,
    name,
    password,
    confirmPassword,
    phonenumber,
  }) => {
    if (confirmPassword !== password) {
      window.alert("Password and Confrim Password should match");
      setValue("confirmPassword", "");
      setValue("password", "");
    } else {
      try {
        const data = await axios.post(
          "https://auth-service-capstone.herokuapp.com/api/v1/register",
          { firstName, lastName, email, password, phone: phonenumber },
          { headers: { randomToken: randomToken } }
        );

        const { status } = data;
        if (status === 201) {
          window.alert("user registered successfully");
          routerObj.push("/auth/login");
        }
      } catch (error) {
        window.alert(error);
      }
    }
  };
  return (
    <Fragment>
      <Form onSubmit={handleSubmit(sentOtpHandler)}>
        <div className={styleClass.text_box__parent}>
          <Typography
            component="h1"
            variant="h1"
            fontSize="40px"
            className={styleClass.text_box}
          >
            Register
          </Typography>
        </div>
        <List>
          <ListItem>
            <Controller
              name="firstName"
              control={control}
              defaultValue=""
              rules={{
                required: true,
                minLength: 2,
                maxLength: 20,
                pattern: /^[a-zA-Z]/,
              }}
              render={({ field }) => (
                <TextField
                  variant="outlined"
                  fullWidth
                  id="firstName"
                  label="First Name"
                  inputProps={{ type: "firstName" }}
                  type="string"
                  error={Boolean(errors.firstName)}
                  helperText={
                    errors.firstName
                      ? errors.firstName.type !== "pattern"
                        ? errors.firstName.type < "minLength" ||
                          errors.firstName.type > "maxLength"
                          ? "Name between 2 - 20"
                          : "Name required"
                        : "Name no number"
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
                maxLength: 20,
                pattern: /^[a-zA-Z]/,
              }}
              render={({ field }) => (
                <TextField
                  variant="outlined"
                  fullWidth
                  id="lastName"
                  label="Last Name"
                  inputProps={{ type: "lastName" }}
                  type="string"
                  error={Boolean(errors.lastName)}
                  helperText={
                    errors.lastName
                      ? errors.lastName.type !== "pattern"
                        ? errors.lastName.type < "minLength" ||
                          errors.lastName.type > "maxLength"
                          ? "Name between 2 - 20"
                          : "Name required"
                        : "Name no number"
                      : ""
                  }
                  {...field}
                ></TextField>
              )}
            ></Controller>
          </ListItem>
          <ListItem>
            <Controller
              name="phonenumber"
              control={control}
              defaultValue=""
              rules={{
                required: true,
                pattern:
                  /^(?:(?:\+|0{0,2})91(\s*[\ -]\s*)?|[0]?)?[789]\d{9}|(\d[ -]?){10}\d$/,
              }}
              render={({ field }) => (
                <TextField
                  className={classes.input}
                  variant="outlined"
                  fullWidth
                  id="phonenumber"
                  label="Phone Number"
                  inputProps={{
                    inputMode: "numeric",
                    type: "text",
                    minLength : 10,
                    maxLength : 10,
                  }}
                  error={Boolean(errors.phonenumber)}
                  InputProps={{
                    startAdornment: (
                      <InputAdornment position="start">+91 </InputAdornment>
                    ),
                  }}
                  helperText={
                    errors.phonenumber
                      ? errors.phonenumber.type === "pattern" 
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
                <Controller
                  name="email"
                  control={control}
                  defaultValue=""
                  rules={{
                    required: true,
                    pattern:
                      /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/,
                  }}
                  render={({ field }) => (
                    <TextField
                      variant="outlined"
                      fullWidth
                      id="email"
                      label="Email"
                      InputProps={{
                        startAdornment: (
                          <InputAdornment position="start">
                            <EmailIcon/>
                          </InputAdornment>
                        ),
                        endAdornment: (
                          <InputAdornment >
                            <Button variant="contained" type="submit" color="primary" size="medium">
                               {!otpSent ? "Send OTP" : "Resend OTP"}
                            </Button>
                          </InputAdornment>
                        ),
                      }}
                      inputProps={{ type: "email" }}
                      error={Boolean(errors.email)}
                      helperText={
                        errors.email
                          ? errors.email.type === "pattern"
                            ? "Email is not Valid"
                            : "Email is required"
                          : ""
                      }
                      {...field}
                    ></TextField>
                  )}
                ></Controller>
          </ListItem>
        </List>
      </Form>

      {otpSent && (
        <Form onSubmit={handleSubmit(verifyOtpHandler)}>
          <List>
            <ListItem>
                  <Controller
                    name="enterotp"
                    control={control}
                    defaultValue=""
                    rules={{
                      required: true,
                      minLength: 6,
                      maxLength: 6,
                    }}
                    render={({ field }) => (
                      <TextField
                        className={classes.input}
                        variant="outlined"
                        fullWidth
                        id="enterotp"
                        label="Enter OTP"
                        InputProps={{
                          endAdornment: (
                            <InputAdornment>
                              <Button
                              variant="contained"
                              type="submit"
                              color="primary"
                              size="medium"
                              >
                              Verify OTP
                              </Button>
                            </InputAdornment>
                          ),
                        }}
                        inputProps={{
                          inputMode: "numeric",
                          type: "number",
                          pattern: "[0-9]*",
                        }}
                        error={Boolean(errors.enterotp)}
                        helperText={
                          errors.enterotp
                            ? errors.enterotp.type < "minLength" ||
                              errors.enterotp.type > "maxLength"
                              ? "OTP should be exacty 6 digits"
                              : "OTP is required"
                            : ""
                        }
                        {...field}
                      ></TextField>
                    )}
                  ></Controller>
            </ListItem>
          </List>
        </Form>
      )}

      {verified && (
        <Form onSubmit={handleSubmit(submitHandler)}>
          <List>
            <ListItem>
              <Controller
                name="password"
                control={control}
                defaultValue=""
                rules={{
                  required: true,
                  minLength: 8,
                }}
                render={({ field }) => (
                  <TextField
                    variant="outlined"
                    fullWidth
                    id="password"
                    label="Password"
                    InputProps={{
                      endAdornment: (
                        <InputAdornment>
                          <IconButton onClick={() => {showPasswordState(!showPassword)}}>
                            {showPassword ? <VisibilityOff/> : <Visibility/>}
                          </IconButton>
                        </InputAdornment>
                      ),
                    }}
                    inputProps={{ type: showPassword ? 'text' : 'password' }}
                    error={Boolean(errors.password)}
                    helperText={
                      errors.password
                        ? errors.password.type === "minLength"
                          ? "Password is is less than 8 characters"
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
                name="confirmPassword"
                control={control}
                defaultValue=""
                rules={{
                  required: true,
                  minLength: 8,
                }}
                render={({ field }) => (
                  <TextField
                    variant="outlined"
                    fullWidth
                    id="confirmPassword"
                    label="Confirm Password"
                    InputProps={{
                      endAdornment: (
                        <InputAdornment>
                          <IconButton onClick={() => {showConfirmPasswordState(!showConfirmPassword)}}>
                            {showConfirmPassword ? <VisibilityOff/> : <Visibility/>}
                          </IconButton>
                        </InputAdornment>
                      ),
                    }}
                    inputProps={{ type: showConfirmPassword ? 'text' : 'password' }}
                    error={Boolean(errors.confirmPassword)}
                    helperText={
                      errors.confirmPassword
                        ? errors.confirmPassword.type === "minLength"
                          ? "Password is is less than 8 characters"
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
                Register
              </Button>
            </ListItem>
          </List>
        </Form>
      )}
    </Fragment>
  );
}
