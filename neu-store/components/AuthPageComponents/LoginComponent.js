import {
  Button,
  Link,
  List,
  ListItem,
  TextField,
  Typography,
  Box,
  IconButton,
} from "@mui/material";
import { useForm, Controller } from "react-hook-form";
import NextLink from "next/link";
import Form from "../Form";
import jsCookie from "js-cookie";
import styleClass from "../../styles/HeadingLayout.module.css";
import { useRouter } from "next/router";
import InputAdornment from "@mui/material/InputAdornment";
import EmailIcon from "@mui/icons-material/Email";
import Visibility from "@mui/icons-material/Visibility";
import VisibilityOff from "@mui/icons-material/VisibilityOff";
import axios from "axios";
import client from "../../utils/client";
import { useContext, useEffect, useState } from "react";
import { Store } from "../../utils/Store";
import { urlForThumbnail } from "../../utils/image";

function LoginComponent(props) {
  const router = useRouter();
  const { state, dispatch } = useContext(Store);
  const { userBearerToken, userInfo } = state;
  const [showPassword, showPasswordState] = useState(false);
  useEffect(() => {
    if (userBearerToken !== null) {
      router.push("/");
    }
  }, []);
  const {
    handleSubmit,
    control,
    formState: { errors },
  } = useForm();
  const submitHandler = async ({ email, password }) => {
    try {
      const data = await axios.post(
        "https://auth-service-capstone.herokuapp.com/api/v1/login",
        {
          email,
          password,
        },
        { headers: { typeOfLogin: "WEBB", client: "Windows xp" } }
      );

      const bearerToken = data.data.body;
      const status = data.data.status;

      if (!status) {
        window.alert(body);
      } else {
        dispatch({ type: "ADD_TOKEN", payload: bearerToken });
        jsCookie.set("userBearerToken", JSON.stringify(bearerToken));
        const userProfile = await axios.get(
          "https://auth-service-capstone.herokuapp.com/api/v1/user/profile",
          { headers: { Authorization: `Bearer ${bearerToken}` } }
        );
        const { firstName, lastName, email, phone } = userProfile.data;
        const userDataStore = {
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
        };

        dispatch({ type: "ADD_USER", payload: userDataStore });
        jsCookie.set("userInfo", JSON.stringify(userDataStore));

        //fetching and adding the address
        const { data } = await axios.get(
          "https://auth-service-capstone.herokuapp.com/api/v1/user/address",
          { headers: { Authorization: `Bearer ${bearerToken}` } }
        );
        const { addresses } = data.addresses;
        dispatch({ type: "ADD_ADDRESS", payload: addresses });
        jsCookie.set("userAddress", JSON.stringify(addresses));

        //Fetch cart from API and set cookie
        const cartData = await axios.get(
          "https://auth-service-capstone.herokuapp.com/api/v1/cart",
          { headers: { Authorization: `Bearer ${bearerToken}` } }
        );
        console.log(cartData);
        const cartDataFromApi = cartData["data"];
        const cartDataArr = cartDataFromApi["data"];
        if (cartDataArr === "No Cart Data") {
          const cart = [];
          jsCookie.set("cartItems", JSON.stringify(cart));
          router.push("/");
        }
        const cart = cartDataArr["cart_items"];
        for (let i = 0; i < cart.length; i++) {
          const skuId = cart[i].sku_id;
          const quantity = cart[i].quantity;
          const productType = skuId.split(":")[0];
          const slug = skuId.split(":")[1];
          const fetchData = async () => {
            if (productType === "Smartphone") {
              try {
                const data = await client.fetch(
                  `
                  *[_type == "product" && catagory.productsku.SmartPhone.smartphoneSKU.slug.current == $slug][0]`,
                  { slug }
                );
                const product =
                  data.catagory.productsku.SmartPhone.smartphoneSKU;
                product.productId = data.productId;
                dispatch({
                  type: "CART_ADD_ITEM",
                  payload: {
                    kind: productType,
                    productskuName: product.productskuName,
                    countInStock: product.countInStock,
                    slug: slug,
                    price: product.price,
                    image: urlForThumbnail(product.image),
                    quantity,
                  },
                });
              } catch (err) {
                window.alert("Login Component issue from Sanity: " + err);
              }
            }

            if (productType === "Apparels") {
              try {
                const data = await client.fetch(
                  `
                    *[_type == "product" && catagory.productsku.Apparels.apparelsSKU.slug.current == $slug][0]`,
                  { slug }
                );
                const product = data.catagory.productsku.Apparels.apparelsSKU;
                product.productId = data.productId;
                dispatch({
                  type: "CART_ADD_ITEM",
                  payload: {
                    kind: productType,
                    productskuName: product.productskuName,
                    countInStock: product.countInStock,
                    slug: slug,
                    price: product.price,
                    image: urlForThumbnail(product.image),
                    quantity,
                  },
                });
              } catch (err) {
                window.alert("Login Component issue from Sanity: " + err);
              }
            }
            if (productType === "Tv") {
              try {
                const data = await client.fetch(
                  `
                    *[_type == "product" && catagory.productsku.Tv.TvSKU.slug.current == $slug][0]`,
                  { slug }
                );
                const product = data.catagory.productsku.Tv.TvSKU;
                product.productId = data.productId;
                dispatch({
                  type: "CART_ADD_ITEM",
                  payload: {
                    kind: productType,
                    productskuName: product.productskuName,
                    countInStock: product.countInStock,
                    slug: slug,
                    price: product.price,
                    image: urlForThumbnail(product.image),
                    quantity,
                  },
                });
              } catch (err) {
                window.alert("Login Component issue from Sanity: " + err);
              }
            }
            if (productType === "Laptop") {
              try {
                const data = await client.fetch(
                  `
                    *[_type == "product" && catagory.productsku.Laptop.LaptopSKU.slug.current == $slug][0]`,
                  { slug }
                );
                const product = data.catagory.productsku.Laptop.LaptopSKU;
                product.productId = data.productId;
                dispatch({
                  type: "CART_ADD_ITEM",
                  payload: {
                    kind: productType,
                    productskuName: product.productskuName,
                    countInStock: product.countInStock,
                    slug: slug,
                    price: product.price,
                    image: urlForThumbnail(product.image),
                    quantity,
                  },
                });
              } catch (err) {
                window.alert("Login Component issue from Sanity: " + err);
              }
            }
            if (productType === "Books") {
              try {
                const data = await client.fetch(
                  `
                    *[_type == "product" && catagory.productsku.Books.BooksSKU.slug.current == $slug][0]`,
                  { slug }
                );
                const product = data.catagory.productsku.Books.BooksSKU;
                product.productId = data.productId;
                dispatch({
                  type: "CART_ADD_ITEM",
                  payload: {
                    kind: productType,
                    productskuName: product.productskuName,
                    countInStock: product.countInStock,
                    slug: slug,
                    price: product.price,
                    image: urlForThumbnail(product.image),
                    quantity,
                  },
                });
              } catch (err) {
                window.alert("Login Component issue from Sanity: " + err);
              }
            }
          };
          fetchData();
        }
        router.push("/");
      }
    } catch (error) {
      //window.alert(error.response.data.body);
    }
  };

  return (
    <>
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
              fontSize="40px"
              className={styleClass.text_box}
            >
              Login
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
                    InputProps={{
                      startAdornment: (
                        <InputAdornment position="start">
                          <EmailIcon />
                        </InputAdornment>
                      ),
                    }}
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
              <Controller
                name="password"
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
                    id="password"
                    label="Password"
                    InputProps={{
                      endAdornment: (
                        <InputAdornment>
                          <IconButton
                            onClick={() => {
                              showPasswordState(!showPassword);
                            }}
                          >
                            {showPassword ? <VisibilityOff /> : <Visibility />}
                          </IconButton>
                        </InputAdornment>
                      ),
                    }}
                    inputProps={{ type: showPassword ? "text" : "password" }}
                    error={Boolean(errors.password)}
                    helperText={
                      errors.password
                        ? errors.password.type === "minLength"
                          ? "Password length is more than 5"
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
                Login
              </Button>
            </ListItem>
            <ListItem>
              Do not have an account?{" "}
              <NextLink href="/auth/register" passHref>
                <Link color="primary">Register</Link>
              </NextLink>
            </ListItem>
            <ListItem>
              <NextLink href="/auth/forget-password" passHref>
                <Link color="primary"> Forget Password?</Link>
              </NextLink>
            </ListItem>
          </List>
        </Form>
      </Box>
    </>
  );
}
export default LoginComponent;
