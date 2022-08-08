import { color } from "@mui/system";

const classes = {
  section: {
    marginTop: 1,
    marginBottom: 1,
  },
  smallText: {
    fontSize: "15px",
  },
  //layout
  main: {
    marginTop: 2,
    minHeight: "80vh",
    width:"100%"
  },
  footer: {
    marginTop: 1,
    textAlign: "center",
    backgroundColor : '#990000',
    color:"white"
  },
  appbar: {
    backgroundColor: "#990000",
    "& a": {
      color: "#ffffff",
    },
  },
  toolbar: {
    justifyContent: "space-between",
  },
  brand: {
    fontWeight: "bold",
    fontSize: "1.5rem",
  },
  brandMobile: {
    fontWeight: "bold",
    fontSize: "1rem",
  },

  //search part
  searchForm: {
    border: "1px solid #ffffff",
    backgroundColor: "#ffffff",
    borderRadius: 1,
    //width: "500px",
  },
  searchInput: {
    paddingLeft: 1,
    color: "#000000",
    "& ::placeholder": {
      color: "#606060",
    },
    width: "457px",
  },
  searchInputMobile: {
    paddingLeft: 1,
    color: "#000000",
    "& ::placeholder": {
      color: "#606060",
    },
    height : "30px"
  },
  searchButton: {
    backgroundColor: "#f8c040",
    padding: 1,
    borderRadius: "0 5px 5px 0",
    "& span": {
      color: "#000000",
    },
  },

  searchButtonMobile: {
    backgroundColor: "#f8c040",
    padding: 1,
    borderRadius: "0 5px 5px 0",
    "& span": {
      color: "#000000",
    },
    height : "30px"
  },

  form: {
    width: "100%",
    maxWidth: 800,
    margin: "0 auto",
  },

  review: {
    padding: 2,
    border: "1px solid #ffffff",
  },

  navbarButton: {
    color: '#ffffff',
    textTransform: 'initial',
  },
};

export default classes;
