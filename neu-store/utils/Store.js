import Cookies from "js-cookie";
import { createContext, useReducer } from "react";

export const Store = createContext();

const initialState = {
  darkMode: Cookies.get("darkMode") === "ON" ? true : false,
  userInfo: Cookies.get("userInfo")
    ? JSON.parse(Cookies.get("userInfo"))
    : null,
  userBearerToken: Cookies.get("userBearerToken")
    ? JSON.parse(Cookies.get("userBearerToken"))
    : null,
  userAddress: Cookies.get("userAddress")
    ? JSON.parse(Cookies.get("userAddress"))
    : null,
  cart: {
    cartItems: Cookies.get("cartItems")
      ? JSON.parse(Cookies.get("cartItems"))
      : [],
    shippingAddress: Cookies.get("shippingAddress")
      ? JSON.parse(Cookies.get("shippingAddress"))
      : {},
  },
};

function reducer(state, action) {
  switch (action.type) {
    case "DARK_MODE_ON":
      return { ...state, darkMode: true };
    case "DARK_MODE_OFF":
      return { ...state, darkMode: false };
    case "ADD_TOKEN":
      return { ...state, userBearerToken: action.payload };
    case "LOG_OUT":
      return {
        ...state,
        userInfo: null,
        userBearerToken: null,
        cart: {
          cartItems: [],
        },
        userAddress: null,
      };
    case "CART_ADD_ITEM": {
      const newItem = action.payload;
      const existItem = Array.isArray(state.cart.cartItems)
        ? state.cart.cartItems.find((item) => item.slug === newItem.slug)
        : null;
      const cartItems = existItem
        ? state.cart.cartItems.map((item) =>
            item.slug === existItem.slug ? newItem : item
          )
        : [...state.cart.cartItems, newItem];
      Cookies.set("cartItems", JSON.stringify(cartItems));
      return { ...state, cart: { ...state.cart, cartItems } };
    }
    case "CART_REMOVE_ITEM": {
      const cartItems = state.cart.cartItems.filter(
        (item) => item.slug !== action.payload.slug
      );
      Cookies.set("cartItems", JSON.stringify(cartItems));
      return { ...state, cart: { ...state.cart, cartItems } };
    }
    case "CART_CLEAR":
      Cookies.set("cartItems", JSON.stringify(""));
      return { ...state, cart: { ...state.cart, cartItems: [] } };
    case "ADD_USER":
      return { ...state, userInfo: action.payload };
    case "REMOVE_USER":
      return { ...state, userInfo: null };
    case "ADD_ADDRESS":
      return { ...state, userAddress: action.payload };
    case "DEL_ADDRESS":
      return { ...state, userAddress: null };
    default:
      return state;
  }
}

export function StoreProvider(props) {
  const [state, dispatch] = useReducer(reducer, initialState);
  const value = { state, dispatch };
  return <Store.Provider value={value}>{props.children}</Store.Provider>;
}
