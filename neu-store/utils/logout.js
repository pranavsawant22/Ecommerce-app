import jsCookie from "js-cookie";

function logout(router, dispatch) {
  window.alert("Session Expired please login again");
  jsCookie.remove("userBearerToken");
  jsCookie.remove("userInfo");
  jsCookie.remove("userAddress");
  jsCookie.remove("cartItems");
  dispatch({ type: "LOG_OUT" });
  router.push("/auth/login");
  router.reload(window.location.pathname)
}

export { logout };
