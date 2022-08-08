import { Fragment } from "react";
import { useForm, Controller } from "react-hook-form";
import Form from "../Form";
import { useRouter } from "next/router";
import styleClass from '../../styles/HeadingLayout.module.css'
import {
  Button,
  List,
  ListItem,
  TextField,
  Typography,
  Box,
} from "@mui/material";
import axios from "axios";
export default function ConfirmPasswordComponent(props) {
  const router = useRouter();
  const {
    handleSubmit,
    control,
    formState: { errors },
  } = useForm();

  async function submitHandler({newPassword}) {
    try {
    const data=await axios.post('https://auth-service-capstone.herokuapp.com/api/v1/update-password',{
  'newPassword':newPassword
    },{
      headers:{'randomToken':props.randomToken,'email_id':props.email_id}
    })
    const {body,status}=data.data
    if (status) {
      window.alert(body)
      router.push('/auth/login')
    }
    } catch (error) {
      window.alert(error.response.data.body)
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
              New Password Setup
            </Typography>
          </div>
          <List>
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
