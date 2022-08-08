import { createTheme } from "@mui/material/styles";
import {
  AppBar,
  Box,
  Container,
  CssBaseline,
  Switch,
  ThemeProvider,
  Toolbar,
  Typography,
  Link,
  Stack,
  useMediaQuery,
  IconButton,
  Drawer,
  List,
  ListItem,
  Divider,
  Button,
} from "@mui/material";
import Head from "next/head";
import NextLink from "next/link";
import classes from "../utils/classes";
import { UserProfile } from "./NavBar/UserProfile";
import { Cart } from "./NavBar/Cart";
import { Search } from "./NavBar/Search";
import { useContext, useEffect, useState } from "react";
import { Store } from "../utils/Store";
import jsCookie from "js-cookie";
import style from "../styles/Footer.module.css";
import Image from "next/image";
import MenuIcon from "@mui/icons-material/Menu";
import CancelIcon from "@mui/icons-material/Cancel";

export default function Layout({ title, description, children }) {
  const { state, dispatch } = useContext(Store);
  const { darkMode } = state;
  const [sidbarVisible, setSidebarVisible] = useState(false);

  const isDesktop = useMediaQuery("(min-width:600px)");

  const theme = createTheme({
    components: {
      MuiLink: {
        defaultProps: {
          underline: "hover",
        },
      },
    },
    typography: {
      h1: {
        fontSize: "1.6rem",
        fontWeight: 400,
        margin: "1rem 0",
      },
      h2: {
        fontSize: "1.4rem",
        fontWeight: 400,
        margin: "1rem 0",
      },
    },
    palette: {
      mode: darkMode ? "dark" : "light",
      primary: {
        main: "#f0c000",
      },
      secondary: {
        main: "#208080",
      },
    },
  });

  const sidebarOpenHandler = () => {
    setSidebarVisible(true);
  };

  const sidebarCloseHandler = () => {
    setSidebarVisible(false);
  };

  const darkModeChangeHandler = () => {
    dispatch({ type: darkMode ? "DARK_MODE_OFF" : "DARK_MODE_ON" });
    const newDarkMode = !darkMode;
    jsCookie.set("darkMode", newDarkMode ? "ON" : "OFF");
  };

  return (
    <>
      <Head>
        <title>{title ? `${title} - Neu Store` : "Neu Store"}</title>
        {description && <meta name="description" content={description}></meta>}
      </Head>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <AppBar position="static" sx={classes.appbar}>
          <Toolbar sx={classes.toolbar}>
            <NextLink href="/" passHref>
              <Link>
                <Box>
                  <Typography
                    sx={isDesktop ? classes.brand : classes.brandMobile}
                  >
                    Neu Store
                  </Typography>
                </Box>
              </Link>
            </NextLink>
            <>
              {!isDesktop && (
                <Drawer
                  anchor="right"
                  open={sidbarVisible}
                  onClose={sidebarCloseHandler}
                >
                  <List>
                    <ListItem>
                      <Box
                        display="flex"
                        alignItems="left"
                        justifyContent="space-between"
                      >
                        <Typography>Neu Store</Typography>
                        <IconButton
                          aria-label="close"
                          onClick={sidebarCloseHandler}
                        >
                          <CancelIcon />
                        </IconButton>
                      </Box>
                    </ListItem>
                    <Divider light />
                    <ListItem>
                      <Cart />
                    </ListItem>
                    <ListItem>
                      <UserProfile />
                    </ListItem>
                    <ListItem>
                      <Switch
                        checked={darkMode}
                        onChange={darkModeChangeHandler}
                      ></Switch>
                    </ListItem>
                  </List>
                </Drawer>
              )}
            </>
            <Box>
              <Search />
            </Box>
            <>
              {!isDesktop && (
                <IconButton
                  edge="start"
                  aria-label="open drawer"
                  onClick={sidebarOpenHandler}
                  sx={classes.menuButton}
                >
                  <MenuIcon color="primary" sx={classes.navbarButton} />
                </IconButton>
              )}
            </>
            {isDesktop && (
              <Box>
                <Cart />
                <UserProfile />
                <Switch
                  checked={darkMode}
                  onChange={darkModeChangeHandler}
                ></Switch>
              </Box>
            )}
          </Toolbar>
        </AppBar>
        <Container component="main" sx={classes.main}>
          {children}
        </Container>
        <Box component="footer" sx={classes.footer}>
          <footer className={style.footer}>
            <NextLink href="/" passHref>
              <Link>
                <h3>
                  &copy; The Neu Store, 2022. All rights reserved.{" "}
                  <span className={style.logo}>
                    <Image
                      src="/neulogo.webp"
                      alt="Vercel Logo"
                      height={25}
                      width={25}
                      layout="fixed"
                    />
                  </span>
                </h3>
              </Link>
            </NextLink>
          </footer>
        </Box>
      </ThemeProvider>
    </>
  );
}
