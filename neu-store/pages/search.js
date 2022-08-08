import {
  Alert,
  Button,
  CircularProgress,
  Grid,
  List,
  ListItem,
  MenuItem,
  Select,
  Typography,
} from "@mui/material";
import { Box } from "@mui/system";
import axios from "axios";
import { useRouter } from "next/router";
import { useSnackbar } from "notistack";
import React, { useContext, useEffect, useState } from "react";
import ProductInPLP from "../components/ProductInPLP";
import classes from "../utils/classes";

const prices = [
  {
    id: 0,
    name: "No Filter",
    value: "",
  },
  {
    id: 1,
    name: "High to Low",
    value: "price:desc",
  },
  {
    id: 2,
    name: "Low to High",
    value: "price:asc",
  },
];

const ratings = [
  {
    id: 0,
    name: "No Filter",
    value: "",
  },
  {
    id: 1,
    name: "High to Low",
    value: "rating:desc",
  },
  {
    id: 2,
    name: "Low to High",
    value: "rating:asc",
  },
];


export default function SearchScreen() {
  const router = useRouter();
  const [pricevalue, setPriceValue] = useState(0);
  const [ratingvalue, setRatingValue] = useState(0);

  const { query = "all" } = router.query;

  const [state, setState] = useState({
    products: [],
    error: "",
    loading: true,
  });

  const { loading, products, error } = state;

  useEffect(() => {
    const fetchData = async () => {
      console.log(query);
      const q = query;
      try {
        setState({ loading: true });
        
        const priceFilter =  prices[pricevalue].value
        const ratingFilter = ratings[ratingvalue].value 
        console.log("ratingvalue -" + ratingFilter);

        const sortBy = priceFilter.length > 0 ? priceFilter : ratingFilter
        
        const { data } = await axios.post(
          "https://auth-service-capstone.herokuapp.com/api/v1/search",
          { q: q , sort_by : sortBy}
        );
        products = data;
        if(products.length  === 0) throw "No Products Found";
        setState({ products, loading: false });
      } catch (err) {
        setState({ error: err, loading: false });
      }
    };
    fetchData();
  }, [query , pricevalue , ratingvalue ]);

  const priceHandleChange = (e) => {
    setPriceValue(e.target.value);
  };

  const ratingHandleChange = (e) => {
    setRatingValue(e.target.value);
  };
  
  return (
    <>
       <Grid sx={classes.section} container spacing={2}>
        <Grid item md={3}>
          <List>
            <ListItem>
              <Box sx={classes.fullWidth}>
                <Typography>Prices</Typography>
                <Select
                  labelId="demo-simple-select-label"
                  id="demo-simple-select"
                  value={pricevalue}
                  label="prices"
                  onChange={priceHandleChange}
                >
                  {prices?.map((price) => (
                    <MenuItem value={price.id}>{price.name}</MenuItem>
                  ))}
                </Select>
              </Box>
            </ListItem>
          </List>
          <List>
            <ListItem>
              <Box sx={classes.fullWidth}>
                <Typography>Ratings</Typography>
                <Select
                  labelId="demo-simple-select-label-for-rating"
                  id="demo-simple-select-label-for-rating"
                  value={ratingvalue}
                  label="ratings"
                  onChange={ratingHandleChange}
                >
                  {ratings?.map((rating) => (
                    <MenuItem value={rating.id}>{rating.name}</MenuItem>
                  ))}
                </Select>
              </Box>
            </ListItem>
          </List>
        </Grid>
        <Grid item md={9}>
          <Grid sx={classes.section} container spacing={3}>
            {loading ? (
              <CircularProgress />
            ) : error ? (
              <Alert>{error}</Alert>
            ) : (
              <Grid container spacing={3}>
                {products.map((product) => (
                  <Grid item md={4} key={product.name}>
                    <ProductInPLP product={product} />
                  </Grid>
                ))}
              </Grid>
            )}
          </Grid>
        </Grid>
      </Grid>
    </>
  );
}
