import Form from "../Form";
import { makeStyles } from "@material-ui/core/styles";
import { useForm, Controller } from "react-hook-form";
import {
  Button,
  Link,
  List,
  ListItem,
  TextField,
  Typography,
  Box,
} from "@mui/material";
import ConfirmPasswordComponent from './ConfirmPasswordComponent'
import styleClass from '../../styles/HeadingLayout.module.css'
import { useState } from "react";
import axios from "axios";
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
function ForgotPasswordComponent(props) {
  const [randomToken, setRandomToken] = useState('');
  const [userEmail, setEmail] = useState('');
  const classes = useStyles();
  const [otpSent, setOtp] = useState(false);
  const {
    handleSubmit,
    control,
    formState: { errors },
  } = useForm();
  const sentOtpHandler = async ({ email }) => {
    try {
      userEmail=email
      const { data } = await axios.get(
        "https://auth-service-capstone.herokuapp.com/api/v1/check-email",
        { headers: { 'email': email } }
      );

      if (data.status) {
        const { data, status } = await axios.post(
          "https://auth-service-capstone.herokuapp.com/api/v1/send-otp",
          { email: email }
        );
        if (status === 200) {
          setOtp(true);
        }
        
      } else {
        window.alert("you are not registered");
        routerObj.push("/auth/register");
      }
    } catch (error) {
      
    }
  };
  const verifyOtpHandler = async ({ email, otp }) => {
    try {
      const data = await axios.post(
        "https://auth-service-capstone.herokuapp.com/api/v1/validate-otp",
        { email: email, otp:otp }
      );
      const { body, status } = data.data;
      setEmail(email)
      setRandomToken(body)
      
    } catch (error) {
      const {body,status}=error.response.data
      window.alert(body);
      setOtp(false);
    }
  };
  return (
    <>
      {randomToken===''?(<Box
        sx={{
          marginTop: 8,
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
        }}
      >
        <Form onSubmit={handleSubmit(sentOtpHandler)}>
        <div className={styleClass.text_box__parent}>
            <Typography
              component="h1"
              variant="h1"
              align="center"
              className={styleClass.text_box}
              fontSize="40px"
            >
              Forget Password
            </Typography>
          </div>
          <List>
            <ListItem>
              <Controller
                name="email"
                control={control}
                defaultValue=""
                rules={{
                  required: true,
                  pattern: /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/,
                }}
                render={({ field }) => (
                  <TextField
                    variant="outlined"
                    fullWidth
                    id="email"
                    label="Email"
                    inputProps={{ type: "email" }}
                    error={Boolean(errors.email)}
                    helperText={
                      errors.email
                        ? errors.email.type === "pattern"
                          ? "Email is not valid"
                          : "Email is required"
                        : ""
                    }
                    {...field}
                  ></TextField>
                )}
              ></Controller>
            </ListItem>
            <ListItem>
              <Button variant="contained" type="submit" color="primary">
                {otpSent ? "Resend OTP" : "Send OTP"}
              </Button>
            </ListItem>
          </List>
        </Form>
        {otpSent && (
          <Form onSubmit={handleSubmit(verifyOtpHandler)}>
            <List>
              <ListItem>
                <Controller
                  name="otp"
                  control={control}
                  defaultValue=""
                  rules={{
                    required: true,
                    minLength: 6,
                  }}
                  render={({ field }) => (
                    <TextField
                      className={classes.input}
                      variant="outlined"
                      id="otp"
                      label="Enter OTP"
                      inputProps={{ type: "number" }}
                      error={Boolean(errors.otp)}
                      helperText={
                        errors.otp
                          ? errors.otp.type === "minLength"
                            ? "Please enter 6 digit no sent on your email Id"
                            : "OTP is required"
                          : ""
                      }
                      {...field}
                    ></TextField>
                  )}
                ></Controller>
              </ListItem>
              <ListItem>
                <Button variant="contained" type="submit" color="primary">
                  Verify OTP
                </Button>
              </ListItem>
            </List>
          </Form>
        )}
      </Box>):<ConfirmPasswordComponent randomToken={randomToken} email_id={userEmail}/>}
    </>
  );
}
export default ForgotPasswordComponent;
