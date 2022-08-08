import React from "react";
import { Button, Link, Menu, MenuItem, Typography } from "@mui/material";
import AccountCircleIcon from "@mui/icons-material/AccountCircle";
import NextLink from "next/link";
import classes from "../../utils/classes";
import { useState, useContext } from "react";
import { useRouter } from "next/router";
import { Store } from "../../utils/Store";
import axios from "axios";
import jsCookie from "js-cookie";
import { logout } from "../../utils/logout";

export const UserProfile = () => {
  const { state, dispatch } = useContext(Store);
  const { userBearerToken, userInfo } = state;

  const router = useRouter();
  const [anchorEl, setAnchorEl] = useState(null);

  const loginClickHandler = (e) => {
    setAnchorEl(e.currentTarget);
  };

  const loginMenuCloseHandler = (e, redirect) => {
    setAnchorEl(null);
    redirect = redirect === "backdropClick" ? false : redirect;
    if (redirect) {
      router.push(redirect);
    }
  };

  const logoutClickHandler = async (e) => {
    try {
      const data = await axios.post(
        "https://auth-service-capstone.herokuapp.com/api/v1/logout",
        {},
        { headers: { Authorization: `Bearer ${userBearerToken}` } }
      );
      dispatch({ type: "LOG_OUT" });
      jsCookie.remove("userBearerToken");
      jsCookie.remove("userInfo");
      jsCookie.remove("userAddress");
      jsCookie.remove("cartItems");
      router.push("/auth/login");
    } catch (error) {
      if (error.message.includes("401")) {
        logout(router, dispatch);
      } else {
        window.alert("Something Went Wrong please try again later");
      }
    }
    setAnchorEl(null);
  };

  const changePasswordHandler = (e, redirect) => {
    setAnchorEl(null);
    redirect = redirect === "backdropClick" ? false : redirect;
    if (redirect) {
      router.push(redirect);
    }
  };

  return (
    <>
      {userInfo ? (
        <>
          <Button
            aria-controls="simple-menu"
            aria-haspopup="true"
            sx={classes.navbarButton}
            onClick={loginClickHandler}
          >
            <Typography color="primary">{userInfo.firstName}</Typography>
            <AccountCircleIcon color="primary" />
          </Button>
          <Menu
            id="simple-menu"
            anchorEl={anchorEl}
            keepMounted
            open={Boolean(anchorEl)}
            onClose={loginMenuCloseHandler}
          >
            <MenuItem
              onClick={(e) => loginMenuCloseHandler(e, "/editUserProfile")}
            >
              Edit User Profile
            </MenuItem>
            <MenuItem
              onClick={(e) => loginMenuCloseHandler(e, "/orderhistory")}
            >
              Order History
            </MenuItem>
            <MenuItem onClick={(e) => loginMenuCloseHandler(e, "/wishlist")}>
              Wishlist
            </MenuItem>
            <MenuItem onClick={(e) => loginMenuCloseHandler(e, "/address")}>
              Addresses
            </MenuItem>
            <MenuItem
              onClick={(e) => changePasswordHandler(e, "/auth/change-password")}
            >
              Change Password
            </MenuItem>
            <MenuItem onClick={logoutClickHandler}>Logout</MenuItem>
          </Menu>
        </>
      ) : (
        <NextLink href="/auth/login" passHref>
          <Link>Login</Link>
        </NextLink>
      )}
    </>
  );
};
